import "package:flutter_bloc/flutter_bloc.dart";
import "package:injectable/injectable.dart";
import "package:news/core/type/option.dart";
import "package:news/feed/domain/dto/category.dart";
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
  final ArticleCategory? category;
  final List<Article> articles;
  final int page;
  final bool reachedTheEnd;

  const ArticlesListState({
    this.search,
    this.category,
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
  final Option<String>? search;
  final Option<ArticleCategory>? category;

  const ReloadArticlesEvent({this.search, this.category});
}

class LoadNextPageEvent extends ArticlesEvent {
  const LoadNextPageEvent();
}

@Singleton()
class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  SearchArticles searchArticles;

  ArticlesBloc(this.searchArticles) : super(const ArticlesLoadingState()) {
    on<ReloadArticlesEvent>((event, emit) async {
      final Response<SearchResult> response = await searchArticles(
        event.search?.value,
        event.category?.value,
        1,
      );

      ArticlesState newState;
      if (response.succeeded) {
        final state = this.state;
        final isList = state is ArticlesListState;
        newState = ArticlesListState(
          search:
              event.search != null
                  ? event.search?.value
                  : (isList ? state.search : null),
          category:
              event.category != null
                  ? event.category?.value
                  : (isList ? state.category : null),
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
        state.category,
        state.page + 1,
      );

      ArticlesState newState;
      if (response.succeeded) {
        newState = ArticlesListState(
          search: state.search,
          category: state.category,
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
