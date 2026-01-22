import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';

class GetSavedArticlesUseCase {
  final BookmarkRepository _bookmarkRepository;

  GetSavedArticlesUseCase(this._bookmarkRepository);

  List<Article> call() {
    return _bookmarkRepository.getSavedArticles();
  }
}