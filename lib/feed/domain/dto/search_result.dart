import "package:news/feed/domain/model/article.dart";

class SearchResult {
  final List<Article> articles;
  final bool reachedTheEnd;

  const SearchResult({required this.articles, required this.reachedTheEnd});
}
