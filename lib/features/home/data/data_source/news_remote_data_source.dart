import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/core/network/api_client.dart';
import 'package:new_nuntium/core/network/api_constants.dart';

/// Contract for the remote data source
abstract class BaseNewsRemoteDataSource {
  Future<List<Article>> fetchTopHeadlines({required String category});
  Future<List<Article>> searchNews({required String query});
}

class NewsRemoteDataSource implements BaseNewsRemoteDataSource {
  final ApiClient _apiClient;

  NewsRemoteDataSource(this._apiClient);

  @override
  Future<List<Article>> fetchTopHeadlines({
    required String category,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.topHeadlines,
      queryParams: {
        'country': 'us',
        'category': category.toLowerCase(),
        'page': page, // إرسال رقم الصفحة
        'pageSize': pageSize,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> articlesJson = response.data['articles'];

      return articlesJson
          .map((json) => Article.fromMap(json, category: category))
          .where((article) => article.title != '[Removed]')
          .toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Future<List<Article>> searchNews({required String query}) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.everything,
        queryParams: {
          ApiConstants.paramQ: query,
          'sortBy': 'publishedAt', // Sort by newest
          ApiConstants.paramPageSize: ApiConstants.defaultPageSize,
        },
      );

      if (response.data != null && response.data['articles'] != null) {
        final List<dynamic> articlesJson = response.data['articles'];

        return articlesJson
            .map((json) => Article.fromMap(json, category: 'Search Results'))
            .where((article) => article.title != '[Removed]')
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }
}
