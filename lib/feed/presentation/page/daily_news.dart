import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:news/feed/presentation/bloc/articles_bloc.dart";
import "package:news/feed/presentation/widget/article_card.dart";

class DailyNews extends StatelessWidget {
  const DailyNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(), body: _buildBody());
  }

  AppBar _buildAppbar() {
    return AppBar(title: const Text("Daily news"));
  }

  Widget _buildBody() {
    return BlocBuilder<ArticlesBloc, ArticlesState>(
      builder: (context, state) {
        if (state is ArticlesLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ArticlesLoadedState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.separated(
              itemCount: state.articles.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, index) {
                return ArticleCard(state.articles[index]);
              },
            ),
          );
        }

        if (state is ArticlesErrorState) {
          return Center(child: Text(state.message));
        }

        throw Exception("Unhandled state: $state");
      },
    );
  }
}
