import 'dart:async';

import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/core/services/storage_service.dart';
import 'package:new_nuntium/features/bookmarks/domain/entity/bookmark_event.dart';
import 'package:new_nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  BookmarkRepositoryImpl(this._storageService);

  final StorageService _storageService;
  final _controller = StreamController<BookmarkChangeEvent>.broadcast();

  @override
  Stream<BookmarkChangeEvent> get bookmarksStream => _controller.stream;

  @override
  Future<void> saveBookmark(Article article) async {
    await _storageService.saveBookmark(article);

    // Emit ADDED event with the article
    _controller.add(
      BookmarkChangeEvent(action: BookmarkAction.added, article: article),
    );
  }

  @override
  Future<void> deleteBookmark(Article article) async {
    await _storageService.deleteBookmark(article.id);

    // Emit REMOVED event
    _controller.add(
      BookmarkChangeEvent(action: BookmarkAction.removed, article: article),
    );
  }

  @override
  bool isArticleSaved(String id) {
    return _storageService.isArticleSaved(id);
  }

  @override
  List<Article> getSavedArticles() {
    return _storageService.getAllBookmarks();
  }
}
