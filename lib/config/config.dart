import "package:injectable/injectable.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

@Singleton()
class Config {
  final String newsApiKey;

  const Config({required this.newsApiKey});

  @FactoryMethod(preResolve: true)
  static Future<Config> create() async {
    await dotenv.load(fileName: ".env");

    return Config(newsApiKey: dotenv.env["NEWS_API_KEY"]!);
  }
}
