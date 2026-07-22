import 'package:dio/dio.dart';
import 'package:nuntium/core/errors/exceptions.dart';

/// Handle Dio Exceptions and convert them into App defined Exceptions.
AppException handleDioError(Exception error) {
  if (error is! DioException) {
    throw UnknownException("Unexpected error occurred: $error");
  }

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.connectionError:
      throw OfflineException();

    case DioExceptionType.badResponse:
    default:
      final data = error.response?.data;
      final message = (data is Map && data['message'] != null)
          ? data['message'].toString()
          : "Server Error";
      throw ServerException(message, statusCode: error.response?.statusCode);
  }
}
