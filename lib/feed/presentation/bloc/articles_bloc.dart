//events : load
//states : loading, loaded, error

import "package:flutter_bloc/flutter_bloc.dart";
import "package:injectable/injectable.dart";
import "package:news/feed/domain/model/article.dart";

import "../../../core/type/response.dart";
import "../../domain/usecase/get_articles.dart";

abstract class ArticlesState {
  const ArticlesState();
}

class ArticlesLoadingState extends ArticlesState {
  const ArticlesLoadingState();
}

class ArticlesLoadedState extends ArticlesState {
  final List<Article> articles;

  const ArticlesLoadedState(this.articles);
}

class ArticlesErrorState extends ArticlesState {
  final String message;

  const ArticlesErrorState(this.message);
}

abstract class ArticlesEvent {
  const ArticlesEvent();
}

class LoadArticlesEvent extends ArticlesEvent {
  const LoadArticlesEvent();
}

@Singleton()
class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  GetArticles getArticles;

  ArticlesBloc(this.getArticles): super(const ArticlesLoadingState()) {
    on<LoadArticlesEvent>((LoadArticlesEvent event, Emitter<ArticlesState> emit) async {
      emit(const ArticlesLoadingState());

      final Response<List<Article>> response = await getArticles();
      if (response.succeeded) {
        emit(ArticlesLoadedState(response.data!));
      } else {
        emit(ArticlesErrorState(response.error!.message));
      }
    });
  }
}
