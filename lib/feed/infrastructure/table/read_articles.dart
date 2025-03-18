import "package:drift/drift.dart";

@DataClassName("ReadArticleEntity")
class ReadArticles extends Table {
  TextColumn get url => text()();
  BoolColumn get read => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {url};
}
