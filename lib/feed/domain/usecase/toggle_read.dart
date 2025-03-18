import "package:injectable/injectable.dart";
import "package:news/feed/domain/port/read_article_repository.dart";

@Singleton()
class ToggleRead {
  final ReadArticleRepository readArticleRepository;

  ToggleRead(this.readArticleRepository);

  Future<bool> call(String url, bool? read) async {
    read = read ?? !await readArticleRepository.isRead(url);
    await readArticleRepository.toggleArticle(url, read);

    return read;
  }
}
