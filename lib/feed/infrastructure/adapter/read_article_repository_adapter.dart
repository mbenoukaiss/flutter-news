import "package:drift/drift.dart";
import "package:injectable/injectable.dart";
import "package:news/core/database.dart";
import "package:news/feed/domain/model/read_article.dart";

import "../../domain/port/read_article_repository.dart";

@Singleton(as: ReadArticleRepository)
class ReadArticleRepositoryAdapter implements ReadArticleRepository {
  final AppDatabase database;

  ReadArticleRepositoryAdapter(this.database);

  @override
  Future<List<ReadArticle>> findReadArticles() async {
    return (await database.select(database.readArticles).get())
        .map((row) => ReadArticle(url: row.url, read: row.read))
        .toList();
  }

  @override
  Future<void> toggleArticle(String url, bool read) async {
    await database
        .into(database.readArticles)
        .insertOnConflictUpdate(
          ReadArticlesCompanion.insert(url: url, read: Value(read)),
        );
  }

  @override
  Future<bool> isRead(String url) async {
    final query =
        database.select(database.readArticles)
          ..where((t) => t.url.equals(url))
          ..where((t) => t.read.equals(true));

    return (await query.getSingleOrNull()) != null;
  }
}
