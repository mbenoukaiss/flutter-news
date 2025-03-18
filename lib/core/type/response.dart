import "package:dio/dio.dart";

import "error.dart";

class Response<T> {
  final T? data;
  final Error? error;

  const Response({
    this.data,
    this.error,
  });

  factory Response.success(T data) => Response(data: data);

  factory Response.error(dynamic error) {
    if (error is DioException) {
      return Response(error: Error.fromDio(error));
    } else if(error is String) {
      return Response(error: Error(message: error));
    } else {
      throw ArgumentError("Unknown error type");
    }
  }

  bool get succeeded => data != null;
}