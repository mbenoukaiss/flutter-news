import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:news/feed/presentation/bloc/articles_bloc.dart";
import "package:news/feed/presentation/widget/article_card.dart";

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
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _buildList(context, state),
        );
      },
    );
  }

  Widget _buildList(BuildContext context, ArticlesState state) {
    if (state is ArticlesLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ArticlesLoadedState) {
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
