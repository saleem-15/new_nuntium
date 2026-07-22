import 'package:nuntium/core/errors/exception_handler.dart';
import 'package:nuntium/core/entities/article.dart';
import 'package:nuntium/core/network/api_client.dart';
import 'package:nuntium/core/network/api_constants.dart';

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
    required String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.topHeadlines,
        queryParams: {
          // 'q': 'history',
          'category': category?.toLowerCase(),
          'page': page, // إرسال رقم الصفحة
          'pageSize': pageSize,
        },
      );

      if (response.data != null && response.data['articles'] != null) {
        final List<dynamic> articlesJson = response.data['articles'];
        return articlesJson
            .map((json) => _articleFromMap(json, category: category ?? 'General'))
            .where((article) => article.title != '[Removed]')
            .toList();
      } else {
        return [];
      }
    } on Exception catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<List<Article>> searchNews({
    required String query,
    int page = 1, // Add page
    int pageSize = 20, // Add pageSize
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.everything,
        queryParams: {
          ApiConstants.paramQ: query,
          'sortBy': 'publishedAt',
          ApiConstants.paramPageSize: pageSize,
          ApiConstants.paramPage: page, // Pass page to API
        },
      );

      if (response.data != null && response.data['articles'] != null) {
        final List<dynamic> articlesJson = response.data['articles'];
        return articlesJson
            .map((json) => _articleFromMap(json, category: 'Search Results'))
            .where((article) => article.title != '[Removed]')
            .toList();
      } else {
        return [];
      }
    } on Exception catch (e) {
      throw handleDioError(e);
    }
  }

  Article _articleFromMap(
    Map<String, dynamic> map, {
    String category = 'General',
  }) {
    return Article(
      // بما أن NewsAPI لا تعطي ID، نستخدم الرابط كمفتاح فريد
      id: map['url'] ?? DateTime.now().toIso8601String(),
      title: map['title'] ?? 'No Title',
      category: category,
      sourceName: map['source']?['name'] ?? '',
      imageUrl: map['urlToImage'] ?? 'https://placehold.co/600x400',
      content: map['content'] ?? map['description'] ?? '',
      url: map['url'] ?? '',
    );
  }
}
