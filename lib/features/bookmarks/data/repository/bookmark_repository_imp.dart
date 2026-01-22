import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/core/services/storage_service.dart';
import 'package:new_nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  BookmarkRepositoryImpl(this._storageService);

  final StorageService _storageService;

  @override
  Future<void> saveBookmark(Article article) async {
    await _storageService.saveBookmark(article);
  }

  @override
  Future<void> deleteBookmark(String articleId) async {
    await _storageService.deleteBookmark(articleId);
  }

  @override
  bool isArticleSaved(String id) {
    return _storageService.isArticleSaved(id);
  }
}