import 'package:dartz/dartz.dart';
import 'package:new_nuntium/core/errors/error_handler.dart';
import 'package:new_nuntium/core/errors/failures.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/core/network/network_info.dart';
import 'package:new_nuntium/features/home/domain/repository/news_repository.dart';

import '../data_source/news_remote_data_source.dart';

/// Implementation of the NewsRepository interface.
/// This class coordinates between Remote Data Source (API) and Local Data Source (if any).
class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  NewsRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<Article>>> fetchNews({
    required String category,
    required int page,
    required int pageSize,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(OfflineFailure());
    }

    // Calling the remote data source defined in previous steps
    try {
      final news = await _remoteDataSource.fetchTopHeadlines(
        category: category,
        page: page,
        pageSize: pageSize,
      );

      return Right(news);
    } catch (error, stackTrace) {
      return Left(ErrorHandler.handle(error, stackTrace));
    }
  }
}
