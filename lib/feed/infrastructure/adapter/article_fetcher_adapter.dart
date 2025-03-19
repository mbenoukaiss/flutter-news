import "dart:io";

import "package:dio/dio.dart" show Dio, DioException;
import "package:injectable/injectable.dart";
import "package:news/feed/domain/dto/language.dart";
import "package:news/feed/domain/dto/search_query.dart";
import "package:news/feed/domain/dto/search_result.dart";
import "package:news/feed/domain/port/article_fetcher.dart";

import "../../../config/config.dart";
import "../../../core/type/response.dart";
import "../../domain/model/article.dart";

@Singleton(as: ArticleFetcher)
class ArticleFetcherAdapter implements ArticleFetcher {
  static const int pageLength = 20;

  final String baseUrl = "https://newsapi.org/v2";

  final Config config;
  final Dio dio;

  ArticleFetcherAdapter(this.config, this.dio);

  @override
  Future<Response<SearchResult>> searchArticles(SearchQuery search) async {
    try {
      final response = await dio.get(
        "$baseUrl/top-headlines",
        queryParameters: {
          if (search.query != null) "q": search.query,
          if (search.category != null) "category": search.category!.name,
          if (search.page != null) "page": search.page,
          "language": Language.en.name,
          "pageSize": pageLength,
          "sortBy": "publishedAt",
          "apiKey": config.newsApiKey,
        },
      );

      if (response.data["status"] == "error") {
        if (response.data["code"] == "maximumResultsReached") {
          return Response.success(
            const SearchResult(articles: [], reachedTheEnd: true),
          );
        }
      }
      if (response.statusCode != HttpStatus.ok ||
          response.data["status"] != "ok") {
        return Response.error("News API returned an unknown error");
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

      return Response.success(
        SearchResult(
          articles: articles,
          reachedTheEnd: articles.length < pageLength,
        ),
      );
    } on DioException catch (error) {
      return Response.error(error);
    } catch (error) {
      return Response.error("An error occurred");
    }
  }
}
