import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:news/feed/presentation/bloc/articles_bloc.dart";
import "package:news/feed/presentation/widget/article_card.dart";
import "package:news/feed/presentation/widget/search_input.dart";

class DailyNews extends StatelessWidget {
  const DailyNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: RefreshIndicator(
        child: _buildBody(),
        onRefresh: () async {
          context.read<ArticlesBloc>().add(const LoadArticlesEvent());
        },
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(title: const Text("Daily news"));
  }

  Widget _buildBody() {
    return BlocBuilder<ArticlesBloc, ArticlesState>(
      builder: (context, state) {
        return Column(
          children: [
            SearchInput(
              onChanged: (value) {
                if (value == null) {
                  context.read<ArticlesBloc>().add(const LoadArticlesEvent());
                } else {
                  context.read<ArticlesBloc>().add(SearchArticlesEvent(value));
                }
              },
            ),
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
        itemCount: state.articles.length,
        separatorBuilder: (_, _) => const Divider(),
        itemBuilder: (context, index) {
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
