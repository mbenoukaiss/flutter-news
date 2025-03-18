import "package:dio/dio.dart";
import "package:injectable/injectable.dart";

@module
abstract class Module {
  @Singleton()
  Dio get dio => Dio();
}
