import 'package:new_nuntium/features/bookmarks/domain/entity/bookmark_event.dart';
import 'package:new_nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';

class WatchBookmarksChangesUseCase {
  final BookmarkRepository _repository;

  WatchBookmarksChangesUseCase(this._repository);

  Stream<BookmarkChangeEvent> call() {
    return _repository.bookmarksStream;
  }
}
