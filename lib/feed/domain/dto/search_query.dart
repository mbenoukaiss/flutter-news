import "package:meta/meta.dart";
import "package:news/feed/domain/dto/category.dart";

@immutable
class SearchQuery {
  final String? query;
  final ArticleCategory? category;
  final int? page;

  const SearchQuery({this.query, this.category, this.page});
}
