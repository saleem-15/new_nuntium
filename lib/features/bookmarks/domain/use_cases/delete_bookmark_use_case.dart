import 'package:new_nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';

class DeleteBookmarkUseCase {
  final BookmarkRepository _bookmarkRepository;

  DeleteBookmarkUseCase(this._bookmarkRepository);

  Future<void> call(String articleId) async {
    return await _bookmarkRepository.deleteBookmark(articleId);
  }
}