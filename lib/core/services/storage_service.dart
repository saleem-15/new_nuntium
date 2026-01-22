import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_nuntium/core/models/article.dart';

class StorageService {
  late Box<Article> _bookmarkBox;
  static const String _bookmarkBoxName = 'bookmarks';

  /// Must be called when the app starts
  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ArticleAdapter());
    }

    await _initBookmarkBox();
  }

  Future<void> _initBookmarkBox() async {
    _bookmarkBox = await Hive.openBox<Article>(_bookmarkBoxName);
  }

  Future<void> saveBookmark(Article bookmark) async {
    await _bookmarkBox.put(bookmark.id, bookmark..isSaved = true);
  }

  List<Article> getAllBookmarks() {
    return _bookmarkBox.values.toList();
  }

  Future<void> deleteBookmark(String id) async {
    await _bookmarkBox.delete(id);
  }

  bool isArticleSaved(String id) {
    return _bookmarkBox.containsKey(id);
  }

  Future<void> clearAllBookmarks() async {
    await _bookmarkBox.clear();
  }
}
