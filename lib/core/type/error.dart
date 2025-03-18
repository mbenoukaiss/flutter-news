import "package:dio/dio.dart";

class Error {
  final String message;
  final String? details;
  final dynamic underlying;

  Error({
    required this.message,
    this.details,
    this.underlying,
  });

  factory Error.fromDio(DioException error, {String? message}) {
    return Error(
      message: error.message ?? message ?? "An error occurred",
      details: error.response?.data.toString(),
      underlying: error,
    );
  }
}