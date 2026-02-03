import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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
    return await _dio.get(path, queryParameters: queryParams);
  }
}
