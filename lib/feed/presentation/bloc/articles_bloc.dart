//events : load
//states : loading, loaded, error

import "package:flutter_bloc/flutter_bloc.dart";
import "package:injectable/injectable.dart";
import "package:news/feed/domain/model/article.dart";
import "package:news/feed/domain/usecase/search_articles.dart";
import "package:rxdart/rxdart.dart";

import "../../../core/type/response.dart";
import "../../domain/usecase/get_articles.dart";

abstract class ArticlesState {
  const ArticlesState();
}

class ArticlesLoadingState extends ArticlesState {
  const ArticlesLoadingState();
}

class ArticlesListState extends ArticlesState {
  final String? search;
  final List<Article> articles;

  const ArticlesListState(this.search, this.articles);
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

class SearchArticlesEvent extends ArticlesEvent {
  final String search;

  const SearchArticlesEvent(this.search);
}

@Singleton()
class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  GetArticles getArticles;
  SearchArticles searchArticles;

  ArticlesBloc(this.getArticles, this.searchArticles)
    : super(const ArticlesLoadingState()) {
    on<LoadArticlesEvent>((event, emit) async {
      emit(const ArticlesLoadingState());

      final Response<List<Article>> response = await getArticles();
      if (response.succeeded) {
        emit(ArticlesListState(null, response.data!));
      } else {
        emit(ArticlesErrorState(response.error!.message));
      }
    });

    on<SearchArticlesEvent>(
      (event, emit) async {
        emit(const ArticlesLoadingState());

        final Response<List<Article>> response = await searchArticles(
          event.search,
        );

        if (response.succeeded) {
          emit(ArticlesListState(event.search, response.data!));
        } else {
          emit(ArticlesErrorState(response.error!.message));
        }
      },
      transformer: (events, mapper) {
        return events
            .debounceTime(const Duration(milliseconds: 500))
            .asyncExpand(mapper);
      },
    );
  }
}
