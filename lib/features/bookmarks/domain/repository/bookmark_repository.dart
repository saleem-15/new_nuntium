import 'package:new_nuntium/core/models/article.dart';

import '../entity/bookmark_event.dart';

abstract class BookmarkRepository {
  Future<void> saveBookmark(Article article);
  Future<void> deleteBookmark(Article article);
  bool isArticleSaved(String id);
  List<Article> getSavedArticles();

  Stream<BookmarkChangeEvent> get bookmarksStream;
}
