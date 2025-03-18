import "package:news/feed/domain/model/read_article.dart";

abstract interface class ReadArticleRepository {
  Future<List<ReadArticle>> findReadArticles();

  Future<bool> isRead(String url);

  Future<void> toggleArticle(String url, bool read);
}
