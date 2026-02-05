import 'package:dartz/dartz.dart';
import 'package:new_nuntium/core/errors/failures.dart';
import 'package:new_nuntium/core/models/article.dart';

/// Abstract Interface for News Repository
/// This acts as a contract between the Data Layer and the Domain Layer.
abstract class NewsRepository {
  /// Fetches a list of news articles based on category and pagination params.
  Future<Either<Failure, List<Article>>> fetchNews({
    required String? category,
    required int page,
    required int pageSize,
  });

  Future<Either<Failure, List<Article>>> searchNews({
    required String query,
    required int page,
    required int pageSize,
  });

}
