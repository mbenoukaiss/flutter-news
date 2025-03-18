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
      final response = await dio.get(
        "$baseUrl/top-headlines",
        queryParameters: {
          "country": "us",
          "sortBy": "publishedAt",
          "apiKey": config.newsApiKey,
        },
      );

      if (response.statusCode != HttpStatus.ok ||
          response.data["status"] != "ok") {
        return Response.error("News API returned an error");
      }

      final List<Article> articles = [];
      for (final articleDto in response.data["articles"]) {
        final publishedAt = DateTime.parse(articleDto["publishedAt"]);
        final article = Article(
          url: articleDto["url"],
          author: articleDto["author"] ?? articleDto["source"]["name"],
          title: articleDto["title"],
          description: articleDto["description"],
          imageUrl: articleDto["urlToImage"],
          publishedAt: publishedAt,
        );

        articles.add(article);
      }

      return Response.success(articles);
    } on DioException catch (error) {
      return Response.error(error);
    } catch (error) {
      return Response.error("An error occurred");
    }
  }
}
