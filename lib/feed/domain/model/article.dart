import "package:equatable/equatable.dart";
import "package:meta/meta.dart";

@immutable
class Article extends Equatable {
  final String url;
  final String? author;
  final String title;
  final String? description;
  final String? imageUrl;
  final DateTime publishedAt;

  const Article({
    required this.url,
    required this.author,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
  });

  @override
  List<Object?> get props => [
    url,
    author,
    title,
    description,
    imageUrl,
    publishedAt,
  ];
}
