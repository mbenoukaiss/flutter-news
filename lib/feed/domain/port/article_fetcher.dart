import "package:news/core/type/response.dart";

import "../dto/search_query.dart";
import "../dto/search_result.dart";

abstract interface class ArticleFetcher {
  Future<Response<SearchResult>> searchArticles(SearchQuery search);
}
