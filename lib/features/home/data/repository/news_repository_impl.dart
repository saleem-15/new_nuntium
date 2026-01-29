import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/features/home/domain/repository/news_repository.dart';

import '../data_source/news_remote_data_source.dart';

/// Implementation of the NewsRepository interface.
/// This class coordinates between Remote Data Source (API) and Local Data Source (if any).
class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource _remoteDataSource;

  NewsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Article>> fetchNews({
    required String category,
    required int page,
    required int pageSize,
  }) async {
    // Calling the remote data source defined in previous steps
    return await _remoteDataSource.fetchTopHeadlines(
      category: category,
      page: page,
      pageSize: pageSize,
    );
  }
}
