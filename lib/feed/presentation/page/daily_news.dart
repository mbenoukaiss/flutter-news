import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:news/feed/domain/dto/category.dart";
import "package:news/feed/presentation/bloc/articles_bloc.dart";
import "package:news/feed/presentation/widget/article_card.dart";
import "package:news/feed/presentation/widget/search_input.dart";

import "../../../core/type/option.dart";

class DailyNews extends StatelessWidget {
  const DailyNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: RefreshIndicator(
        child: _buildBody(),
        onRefresh: () async {
          context.read<ArticlesBloc>().add(const ReloadArticlesEvent());
        },
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(title: const Text("Daily news"));
  }

  Widget _filters(BuildContext context, ArticlesState state) {
    return Column(
      children: [
        SearchInput(
          onChanged: (value) {
            context.read<ArticlesBloc>().add(
              ReloadArticlesEvent(search: Option.of(value)),
            );
          },
        ),
        SizedBox(
          height: 50,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: ArticleCategory.values.length,
            separatorBuilder: (_, __) => const SizedBox(width: 5),
            itemBuilder: (context, index) {
              final ArticleCategory cat = ArticleCategory.values[index];

              return ChoiceChip(
                label: Text(cat.toString()),
                selected: state is ArticlesListState && state.category == cat,
                onSelected: (active) {
                  context.read<ArticlesBloc>().add(
                    ReloadArticlesEvent(
                      category: active ? Option(cat) : const Option.none(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ArticlesBloc, ArticlesState>(
      builder: (context, state) {
        return Column(
          children: [
            _filters(context, state),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _buildList(context, state),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildList(BuildContext context, ArticlesState state) {
    if (state is ArticlesLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ArticlesListState) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, _) => const Divider(),
        itemCount: state.articles.length + (state.reachedTheEnd ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= state.articles.length) {
            context.read<ArticlesBloc>().add(const LoadNextPageEvent());

            return const Padding(
              padding: EdgeInsets.all(16),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          return ArticleCard(
            key: Key(index.toString()),
            article: state.articles[index],
          );
        },
      );
    }

    if (state is ArticlesErrorState) {
      return Center(child: Text(state.message));
    }

    throw Exception("Unhandled state: $state");
  }
}
