import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/delete_bookmark_use_case.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/get_saved_articles_use_case.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/watch_bookmarks_changes_use_case.dart';
import 'package:new_nuntium/routes/routes.dart';

class BookmarksController extends GetxController {
  // --- Dependencies ---
  final _getSavedArticlesUseCase = getIt<GetSavedArticlesUseCase>();
  final _deleteBookmarkUseCase = getIt<DeleteBookmarkUseCase>();
  final _watchBookmarksUseCase = getIt<WatchBookmarksChangesUseCase>();
  StreamSubscription? _bookmarksSubscription;

  // --- State ---
  var articles = <Article>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getSavedArticles();

    _bookmarksSubscription = _watchBookmarksUseCase.call().listen(
      (_) => getSavedArticles(),
    );
  }

  void getSavedArticles() {
    isLoading.value = true;
    try {
      final savedArticles = _getSavedArticlesUseCase.call();

      // The list is reversed, So the newest articles that was added appears at Top
      articles.assignAll(savedArticles.reversed.toList());
    } finally {
      isLoading.value = false;
    }
  }

  void onBookmarkTapped(Article tappedArticle) {
    log("Article ${tappedArticle.title} is Tapped");
    Get.toNamed(Routes.articleView, arguments: tappedArticle);
  }

  void fetchBookmarksIfNeeded() {}

  Future<void> removeBookmark(Article article) async {
    await _deleteBookmarkUseCase.call(article);
    articles.remove(article);
  }

  @override
  void onClose() {
    _bookmarksSubscription?.cancel();
    super.onClose();
  }
}
