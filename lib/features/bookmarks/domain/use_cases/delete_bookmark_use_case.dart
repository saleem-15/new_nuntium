import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';

class DeleteBookmarkUseCase {
  final BookmarkRepository _bookmarkRepository;

  DeleteBookmarkUseCase(this._bookmarkRepository);

  Future<void> call(Article article) async {
    return await _bookmarkRepository.deleteBookmark(article);
  }
}
