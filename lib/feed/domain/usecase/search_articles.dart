import "package:injectable/injectable.dart";
import "package:news/feed/domain/model/article.dart";
import "package:news/feed/domain/port/article_fetcher.dart";

import "../../../core/type/response.dart";

@Singleton()
class SearchArticles {
  final ArticleFetcher articleFetcher;

  SearchArticles(this.articleFetcher);

  Future<Response<List<Article>>> call(String search) async {
    return articleFetcher.searchArticles(search);
  }
}
