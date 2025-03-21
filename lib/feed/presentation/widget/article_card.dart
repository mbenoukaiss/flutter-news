import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:news/config/getit.dart";
import "package:news/feed/domain/model/article.dart";
import "package:news/feed/presentation/bloc/read_articles_bloc.dart";
import "package:url_launcher/url_launcher_string.dart";

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({required Key super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReadArticleBloc>(
      create: (context) {
        return getIt(param1: article.url)..add(const LoadStatusEvent());
      },
      child: BlocBuilder<ReadArticleBloc, ReadArticleState>(builder: _card),
    );
  }

  Widget _card(BuildContext context, ReadArticleState state) {
    final readBloc = context.read<ReadArticleBloc>();
    final bool isRead = state is ReadArticleLoadedState && state.read;

    final Widget content = Row(
      spacing: 10,
      children: [_image(context), _content(context)],
    );

    return GestureDetector(
      onTap: () async {
        readBloc.add(ToggleArticleEvent(article.url, true));
        await launchUrlString(article.url);
      },
      child: Dismissible(
        key: key!,
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          readBloc.add(ToggleArticleEvent(article.url, null));
          return false;
        },
        background: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.mark_email_read, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                isRead ? "Mark as unread" : "Mark as read",
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
        child: isRead ? Opacity(opacity: 0.5, child: content) : content,
      ),
    );
  }

  Widget _content(BuildContext context) {
    final String locale = Intl.getCurrentLocale();

    return Flexible(
      flex: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            "${article.description ?? "No description available"}\n",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontStyle:
                  article.description == null
                      ? FontStyle.italic
                      : FontStyle.normal,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  article.author ?? "Unknown",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                DateFormat.yMd(locale).add_jm().format(article.publishedAt),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _image(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withAlpha(0x22),
          borderRadius: BorderRadius.circular(16),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: CachedNetworkImage(
            imageUrl: article.imageUrl ?? "https://placehold.co/200",
            placeholder: (_, _) {
              return const Center(
                child: const SizedBox(
                  width: 32,
                  height: 32,
                  child: const CircularProgressIndicator(),
                ),
              );
            },
            imageBuilder: (context, imageProvider) {
              return FittedBox(
                fit: BoxFit.cover,
                child: Image(image: imageProvider),
              );
            },
            errorWidget: (context, url, error) {
              return const Icon(
                Icons.image_not_supported_outlined,
                color: Colors.white,
              );
            },
          ),
        ),
      ),
    );
  }
}
