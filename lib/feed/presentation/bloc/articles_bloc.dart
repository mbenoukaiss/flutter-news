import "package:flutter_bloc/flutter_bloc.dart";
import "package:injectable/injectable.dart";
import "package:news/feed/domain/dto/search_result.dart";
import "package:news/feed/domain/model/article.dart";
import "package:news/feed/domain/usecase/search_articles.dart";
import "package:rxdart/rxdart.dart";

import "../../../core/type/response.dart";

abstract class ArticlesState {
  const ArticlesState();
}

class ArticlesLoadingState extends ArticlesState {
  const ArticlesLoadingState();
}

class ArticlesListState extends ArticlesState {
  final String? search;
  final List<Article> articles;
  final int page;
  final bool reachedTheEnd;

  const ArticlesListState({
    this.search,
    required this.articles,
    required this.page,
    required this.reachedTheEnd,
  });
}

class ArticlesErrorState extends ArticlesState {
  final String message;

  const ArticlesErrorState(this.message);
}

abstract class ArticlesEvent {
  const ArticlesEvent();
}

class ReloadArticlesEvent extends ArticlesEvent {
  final String? search;

  const ReloadArticlesEvent({this.search});
}

class LoadNextPageEvent extends ArticlesEvent {
  const LoadNextPageEvent();
}

@Singleton()
class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  SearchArticles searchArticles;

  ArticlesBloc(this.searchArticles) : super(const ArticlesLoadingState()) {
    on<ReloadArticlesEvent>((event, emit) async {
      emit(const ArticlesLoadingState());

      final Response<SearchResult> response = await searchArticles(
        event.search,
        1,
      );

      ArticlesState newState;
      if (response.succeeded) {
        newState = ArticlesListState(
          search: event.search,
          articles: response.data!.articles,
          page: 1,
          reachedTheEnd: response.data!.reachedTheEnd,
        );
      } else {
        newState = ArticlesErrorState(response.error!.message);
      }

      emit(newState);
    }, transformer: _searchDebouncer);

    on<LoadNextPageEvent>((event, emit) async {
      final state = this.state;
      if (state is! ArticlesListState) {
        throw Exception("Invalid state");
      }

      final Response<SearchResult> response = await searchArticles(
        state.search,
        state.page + 1,
      );

      ArticlesState newState;
      if (response.succeeded) {
        newState = ArticlesListState(
          search: state.search,
          articles: [...state.articles, ...response.data!.articles],
          page: state.page + 1,
          reachedTheEnd: response.data!.reachedTheEnd,
        );
      } else {
        newState = ArticlesErrorState(response.error!.message);
      }

      emit(newState);
    });
  }

  Stream<E> _searchDebouncer<E>(Stream<E> events, EventMapper<E> mapper) {
    return events
        .debounceTime(const Duration(milliseconds: 500))
        .asyncExpand(mapper);
  }
}
