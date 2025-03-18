import "package:equatable/equatable.dart";
import "package:meta/meta.dart";

@immutable
class ReadArticle extends Equatable {
  final String url;
  final bool read;

  const ReadArticle({required this.url, required this.read});

  @override
  List<Object?> get props => [url, read];
}
