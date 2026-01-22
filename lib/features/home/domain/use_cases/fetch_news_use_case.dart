import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/features/home/domain/repository/news_repository.dart';

/// Use Case responsible for fetching news.
/// It encapsulates the business logic for retrieving articles.
class FetchNewsUseCase {
  FetchNewsUseCase(this._newsRepository);

  final NewsRepository _newsRepository;

  /// Callable class method to execute the use case
  Future<List<Article>> call({
    required String category,
    required int page,
    required int pageSize,
  }) async {
    return await _newsRepository.fetchNews(
      category: category,
      page: page,
      pageSize: pageSize,
    );
  }
}
