import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';

class SaveBookmarkUseCase {
  final BookmarkRepository _bookmarkRepository;

  SaveBookmarkUseCase(this._bookmarkRepository);

  Future<void> call(Article article) async {
    return await _bookmarkRepository.saveBookmark(article);
  }
}