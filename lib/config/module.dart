import "package:dio/dio.dart";
import "package:injectable/injectable.dart";

import "../core/database.dart";

@module
abstract class Module {
  @Singleton()
  Dio get dio => Dio();

  @Singleton()
  AppDatabase get database => AppDatabase();
}
