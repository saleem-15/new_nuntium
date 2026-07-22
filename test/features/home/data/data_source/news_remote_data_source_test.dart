import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:nuntium/core/errors/exceptions.dart';
import 'package:nuntium/core/network/api_client.dart';
import 'package:nuntium/core/network/api_constants.dart';
import 'package:nuntium/features/home/data/data_source/news_remote_data_source.dart';

import '../../../../helpers/sample_news_response_json.dart';

void main() {
  group('NewsRemoteDataSource', () {
    late DioAdapter dioAdapter;
    late ApiClient apiClient;
    late NewsRemoteDataSource newsRemoteDataSource;

    setUp(() {
      apiClient = ApiClient();
      dioAdapter = DioAdapter(dio: apiClient.dio);
      newsRemoteDataSource = NewsRemoteDataSource(apiClient);
    });

    final queryParams = {
      ApiConstants.paramCategory: 'general',
      ApiConstants.paramPage: 1,
      ApiConstants.paramPageSize: 20,
    };
    group('fetchTopHeadlines', () {
      test(
        'should return list of articles when the response code is 200',
        () async {
          // Arrange
          dioAdapter.onGet(
            ApiConstants.topHeadlines,
            queryParameters: queryParams,
            (server) => server.reply(200, tNewsJsonResponse),
          );

          final result = await newsRemoteDataSource.fetchTopHeadlines(
            category: 'general',
            page: 1,
            pageSize: 20,
          );

          expect(result, tArticlesList);
        },
      );

      test(
        'should return Empty list of articles when no articles are returned from API',
        () async {
          // Arrange
          dioAdapter.onGet(
            ApiConstants.topHeadlines,
            queryParameters: queryParams,
            (server) => server.reply(200, {
              "status": "ok",
              "totalResults": 0,
              'articles': [],
            }),
          );

          final result = await newsRemoteDataSource.fetchTopHeadlines(
            category: 'general',
            page: 1,
            pageSize: 20,
          );

          expect(result, []);
        },
      );

      test(
        'should return Empty list of articles when response articles field is null',
        () async {
          // Arrange
          dioAdapter.onGet(
            ApiConstants.topHeadlines,
            queryParameters: queryParams,
            (server) => server.reply(200, {
              "status": "ok",
              "totalResults": 0,
              'articles': null,
            }),
          );

          final result = await newsRemoteDataSource.fetchTopHeadlines(
            category: 'general',
            page: 1,
            pageSize: 20,
          );

          expect(result, []);
        },
      );
      test(
        'should throw OfflineException when Dio throws connectionTimeout',
        () async {
          // Arrange
          dioAdapter.onGet(
            ApiConstants.topHeadlines,
            queryParameters: queryParams,
            (server) => server.throws(
              400,
              DioException.connectionTimeout(
                timeout: ApiConstants.connectTimeout,
                requestOptions: RequestOptions(),
              ),
            ),
          );

          expect(
            newsRemoteDataSource.fetchTopHeadlines(
              category: 'general',
              page: 1,
              pageSize: 20,
            ),
            throwsA(isA<OfflineException>()),
          );
        },
      );
      test(
        'should throw ServerException when response is error ex: 404 or 500',
        () async {
          // Arrange
          dioAdapter.onGet(
            ApiConstants.topHeadlines,
            queryParameters: queryParams,
            (server) => server.throws(
              500,
              DioException.badResponse(
                requestOptions: RequestOptions(),
                statusCode: 500,
                response: Response(
                  statusMessage: "Internal Server Error",
                  requestOptions: RequestOptions(),
                ),
              ),
            ),
          );

          expect(
            newsRemoteDataSource.fetchTopHeadlines(
              category: 'general',
              page: 1,
              pageSize: 20,
            ),
            throwsA(isA<ServerException>()),
          );
        },
      );
    });
    
    group('searchNews', () {
      final tQuery = 'sports';
      final tPage = 1;
      final tPageSize = 20;

      final searchQueryParams = {
        ApiConstants.paramQ: tQuery,
        'sortBy': 'publishedAt',
        ApiConstants.paramPageSize: tPageSize,
        ApiConstants.paramPage: tPage,
      };

      test(
        'should return List<Article> with category "Search Results" when response code is 200',
        () async {
          // Arrange
          dioAdapter.onGet(
            ApiConstants.everything,
            queryParameters: searchQueryParams,
            (server) => server.reply(200, tNewsJsonResponse),
          );

          // Act
          final result = await newsRemoteDataSource.searchNews(
            query: tQuery,
            page: tPage,
            pageSize: tPageSize,
          );

          // Assert
          final expectedSearchArticles = tArticlesList
              .map((article) => article.copyWith(category: 'Search Results'))
              .toList();

          expect(result, expectedSearchArticles);
        },
      );

      test(
        'should return empty list when the Response articles field is null or empty',
        () async {
          // Arrange
          dioAdapter.onGet(
            ApiConstants.everything,
            queryParameters: searchQueryParams,
            (server) => server.reply(200, {
              "status": "ok",
              "totalResults": 0,
              "articles": null,
            }),
          );

          // Act
          final result = await newsRemoteDataSource.searchNews(
            query: tQuery,
            page: tPage,
            pageSize: tPageSize,
          );

          // Assert
          expect(result, isEmpty);
        },
      );

      test(
        'should throw ServerException when API responds with server error',
        () async {
          // Arrange
          dioAdapter.onGet(
            ApiConstants.everything,
            queryParameters: searchQueryParams,
            (server) => server.throws(
              500,
              DioException.badResponse(
                requestOptions: RequestOptions(),
                statusCode: 500,
                response: Response(
                  statusMessage: "Server Error",
                  requestOptions: RequestOptions(),
                ),
              ),
            ),
          );

          // Act & Assert
          expect(
            newsRemoteDataSource.searchNews(
              query: tQuery,
              page: tPage,
              pageSize: tPageSize,
            ),
            throwsA(isA<ServerException>()),
          );
        },
      );
    });
  });
}
