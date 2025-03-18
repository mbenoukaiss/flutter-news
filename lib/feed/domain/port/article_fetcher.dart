import "package:news/core/type/response.dart";

import "../model/article.dart";

abstract interface class ArticleFetcher {
  Future<Response<List<Article>>> allArticles();

  Future<Response<List<Article>>> searchArticles(String search);
}
