import "package:injectable/injectable.dart";
import "package:news/feed/domain/port/read_article_repository.dart";

@Singleton()
class IsArticleRead {
  final ReadArticleRepository readArticleRepository;

  IsArticleRead(this.readArticleRepository);

  Future<bool> call(String url) async {
    return await readArticleRepository.isRead(url);
  }
}
