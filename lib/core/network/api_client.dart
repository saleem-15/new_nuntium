import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_constants.dart';
import 'api_interceptor.dart';

/// A wrapper around Dio to handle HTTP requests professionally.
class ApiClient {
  late final Dio _dio;

  /// Exposes the inner Dio instance for testing purposes (e.g., attaching Mock Adapters).
  @visibleForTesting
  Dio get dio => _dio;
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
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: false,
          error: true,
          maxWidth: 70,
        ),
    ]);
  }

  /// Generic GET request method.
  ///
  /// [path]: The endpoint path (e.g., '/top-headlines').
  /// [queryParams]: Optional query parameters.
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(path, queryParameters: queryParams);
  }
}
