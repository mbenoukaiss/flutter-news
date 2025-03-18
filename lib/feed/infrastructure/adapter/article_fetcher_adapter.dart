import "dart:io";
import "package:dio/dio.dart" show Dio, DioException;
import "package:injectable/injectable.dart";
import "package:news/feed/domain/port/article_fetcher.dart";

import "../../../config/config.dart";
import "../../../core/type/response.dart";
import "../../domain/model/article.dart";

@Singleton(as: ArticleFetcher)
class ArticleFetcherAdapter implements ArticleFetcher {
  final String baseUrl = "https://newsapi.org/v2";

  final Config config;
  final Dio dio;

  ArticleFetcherAdapter(this.config, this.dio);

  @override
  Future<Response<List<Article>>> fetchArticles() async {
    try {
      final response = await dio.get("$baseUrl/top-headlines", queryParameters: {
        "country": "us",
        "sortBy": "publishedAt",
        "apiKey": config.newsApiKey,
      });

      if (response.statusCode != HttpStatus.ok || response.data["status"] != "ok") {
        return Response.error("News API returned an error");
      }

      final List<Article> articles = [];
      for (final article in response.data["articles"]) {
        final publishedAt = DateTime.parse(article["publishedAt"]);
        final articleDto = Article(
          url: article["url"],
          author: article["author"] ?? article["source"]["name"] ?? null,
          title: article["title"],
          description: article["description"],
          imageUrl: article["urlToImage"],
          publishedAt: publishedAt,
        );

        articles.add(articleDto);
      }

      return Response.success(articles);
    } on DioException catch (error) {
      return Response.error(error);
    } catch (error) {
      return Response.error("An error occurred");
    }
  }
}
