import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:news/feed/domain/model/article.dart";

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard(this.article, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(spacing: 10, children: [_image(context), _content(context)]);
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
            article.description ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          Text(
            "${article.author ?? "Unknown"} | ${DateFormat.yMd(locale).add_jm().format(article.publishedAt)}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12,
            ),
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
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: FittedBox(
            fit: BoxFit.cover,
            child: CachedNetworkImage(
              imageUrl: article.imageUrl ?? "https://placehold.co/200",
              placeholder: (_, _) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) {
                return const Icon(Icons.error, color: Colors.white, size: 10);
              },
            ),
          ),
        ),
      ),
    );
  }
}
