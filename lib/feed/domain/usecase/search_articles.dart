import "package:injectable/injectable.dart";
import "package:news/feed/domain/dto/category.dart";
import "package:news/feed/domain/dto/search_query.dart";
import "package:news/feed/domain/port/article_fetcher.dart";

import "../../../core/type/response.dart";
import "../dto/search_result.dart";

@Singleton()
class SearchArticles {
  final ArticleFetcher articleFetcher;

  SearchArticles(this.articleFetcher);

  Future<Response<SearchResult>> call(
    String? search,
    ArticleCategory? category,
    int page,
  ) async {
    return await articleFetcher.searchArticles(
      SearchQuery(query: search, category: category, page: page),
    );
  }
}
