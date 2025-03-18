class ArticleDto {
  final String url;
  final String author;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime publishedAt;

  const ArticleDto({
    required this.url,
    required this.author,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
  });

}