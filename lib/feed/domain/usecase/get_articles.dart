import "package:injectable/injectable.dart";
import "package:news/feed/domain/model/article.dart";
import "package:news/feed/domain/port/article_fetcher.dart";

import "../../../core/type/response.dart";

@Singleton()
class GetArticles {
  final ArticleFetcher articleFetcher;

  GetArticles(this.articleFetcher);

  Future<Response<List<Article>>> call() async {
    return articleFetcher.fetchArticles();
  }
}