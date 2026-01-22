import 'package:new_nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';

class CheckIfSavedUseCase {
  CheckIfSavedUseCase(this._bookmarkRepository);

  final BookmarkRepository _bookmarkRepository;

  bool call(String id) {
    return _bookmarkRepository.isArticleSaved(id);
  }
}