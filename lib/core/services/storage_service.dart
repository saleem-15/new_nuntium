import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_nuntium/core/models/article.dart';

import 'package:new_nuntium/features/home/data/news_model.dart';

class StorageService {
  late Box<News> _bookmarkBox;
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
    _bookmarkBox = await Hive.openBox<News>(_bookmarkBoxName);
  }

  Future<void> saveBookmark(News bookmark) async {
    await _bookmarkBox.put(bookmark.id, bookmark..isSaved = true);
  }

  List<News> getAllBookmarks() {
    return _bookmarkBox.values.toList();
  }

  Future<void> deleteBookmark(String id) async {
    await _bookmarkBox.delete(id);
  }

  bool isBookmarkSaved(String id) {
    return _bookmarkBox.containsKey(id);
  }

  Future<void> clearAllBookmarks() async {
    await _bookmarkBox.clear();
  }
}
