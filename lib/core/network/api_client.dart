import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../errors/exceptions.dart';
import 'api_constants.dart';
import 'api_interceptor.dart';

/// A wrapper around Dio to handle HTTP requests professionally.
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        responseType: ResponseType.json,
      ),
    );

    // Add Interceptors
    _dio.interceptors.addAll([
      ApiKeyInterceptor(), // Automatically adds the API Key
      if (kDebugMode) // Only log in debug mode to keep release clean
        PrettyDioLogger(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
        ),
    ]);
  }

  /// Generic GET request method.
  ///
  /// [path]: The endpoint path (e.g., '/top-headlines').
  /// [queryParams]: Optional query parameters.
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      // Handle Dio specific errors (timeouts, 404, 500, etc.)
      throw _handleDioError(e);
    } catch (e) {
      // Handle generic errors
      throw Exception("Unexpected error: $e");
    }
  }

  /// Handle Dio Exceptions and convert them into user-friendly messages.
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        throw OfflineException();

      case DioExceptionType.badResponse:
        // Extract the error message from the server if it Exists
        final message = error.response?.data['message'] ?? "Server Error";
        throw ServerException(
           message,
          statusCode: error.response?.statusCode,
        );

      default:
        throw ServerException("Unexpected error occurred: $error");
    }
  }
}
