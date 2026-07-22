import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuntium/core/errors/exception_handler.dart';
import 'package:nuntium/core/errors/exceptions.dart';

void main() {
  setUpAll(() {
    EquatableConfig.stringify = true;
  });

  group("handleDioError", () {
    test("throw OfflineExceptoin when connectionTimeout", () {
      expect(
        () => handleDioError(
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.connectionTimeout,
          ),
        ),
        throwsA(OfflineException()),
      );
    });

    test("throw ServerExceptoin when a bad response returns", () {
      expect(
        () => handleDioError(
          DioException(
            requestOptions: RequestOptions(),
            response: Response(
              data: {"message": "Failed"},
              statusCode: 500,
              requestOptions: RequestOptions(),
            ),
            type: DioExceptionType.badResponse,
          ),
        ),
        throwsA(ServerException("Failed", statusCode: 500)),
      );
    });

    test("throw ServerException with 'Server Error' fallback when response.data is null", () {
      expect(
        () => handleDioError(
          DioException(
            requestOptions: RequestOptions(),
            response: Response(
              data: null,
              statusCode: 500,
              requestOptions: RequestOptions(),
            ),
            type: DioExceptionType.badResponse,
          ),
        ),
        throwsA(ServerException("Server Error", statusCode: 500)),
      );
    });

    test("throw ServerException with 'Server Error' fallback when response.data is not a Map", () {
      expect(
        () => handleDioError(
          DioException(
            requestOptions: RequestOptions(),
            response: Response(
              data: "Internal Error HTML",
              statusCode: 500,
              requestOptions: RequestOptions(),
            ),
            type: DioExceptionType.badResponse,
          ),
        ),
        throwsA(ServerException("Server Error", statusCode: 500)),
      );
    });
  });
}
