import 'package:new_nuntium/core/models/article.dart';

abstract class BookmarkRepository {
  Future<void> saveBookmark(Article article);
  Future<void> deleteBookmark(String articleId);
  bool isArticleSaved(String id); 
}