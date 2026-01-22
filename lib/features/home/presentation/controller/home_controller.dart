import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/features/bookmarks/domain/entity/bookmark_event.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/check_if_saved_use_case.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/watch_bookmarks_changes_use_case.dart';
import 'package:new_nuntium/features/home/domain/use_cases/fetch_news_use_case.dart';
import 'package:new_nuntium/features/home/domain/use_cases/toggle_bookmark_use_case.dart';

class HomeController extends GetxController {
  // ---Dependencies---
  final _fetchNewsUseCase = getIt<FetchNewsUseCase>();

  // Bookmark Use Cases
  final _checkIfArticleSavedUseCase = getIt<CheckIfSavedUseCase>();
  final _toggleBookmarkUseCase = getIt<ToggleBookmarkUseCase>();
  final _watchBookmarksUseCase = getIt<WatchBookmarksChangesUseCase>();
  StreamSubscription? _bookmarksSubscription;

  // ---UI State---
  late FocusNode searchFocusNode;
  final isSearchFieldFocused = false.obs;
  var selectedCategory = "Random".obs;

  final List<String> categories = [
    AppStrings.random,
    AppStrings.sports,
    AppStrings.gaming,
    AppStrings.politics,
    AppStrings.life,
    AppStrings.animals,
    AppStrings.nature,
    AppStrings.food,
    AppStrings.art,
    AppStrings.history,
    AppStrings.fashion,
  ];

  static const int _pageSize = 20;

  late final PagingController<int, Article> pagingController;

  @override
  void onInit() {
    super.onInit();

    searchFocusNode = FocusNode();
    searchFocusNode.addListener(() {
      isSearchFieldFocused.value = searchFocusNode.hasFocus;
    });

    pagingController = PagingController<int, Article>(
      // 1. Logic of Calculating the next page key
      getNextPageKey: (state) {
        if (state.lastPageIsEmpty) return null;

        // التحقق من null قبل الوصول للخصائص
        final keys = state.keys;

        // إذا كانت القائمة null أو فارغة، نبدأ بالصفحة رقم 1
        if (keys == null || keys.isEmpty) {
          return 1;
        }

        // وإلا نزيد آخر مفتاح بـ 1
        return keys.last + 1;
      },

      // 2. منطق جلب البيانات
      fetchPage: (pageKey) async {
        return await _fetchArticles(pageKey);
      },
    );

    _listenToBookmarksChanges();
  }

  ///  Listens to Bookmarks changes and updates the UI accordingly
  void _listenToBookmarksChanges() {
    _watchBookmarksUseCase.call().listen((BookmarkChangeEvent event) {
      final isSaved = event.action == BookmarkAction.added;
      final eventArticleId = event.article.id;

      pagingController.mapItems((article) {
        if (article.id == eventArticleId) {
          article.isSaved = isSaved;
          update([eventArticleId]);
        }
        return article;
      });
    });
  }

  /// دالة لجلب المقالات (تُستدعى تلقائياً بواسطة fetchPage)
  Future<List<Article>> _fetchArticles(int pageKey) async {
    try {
      String categoryParam = selectedCategory.value;
      if (categoryParam == AppStrings.random) categoryParam = 'general';

      final newArticles = await _fetchNewsUseCase(
        category: categoryParam,
        page: pageKey,
        pageSize: _pageSize,
      );

      // تحديث حالة الحفظ
      return newArticles.map((article) {
        article.isSaved = _checkIfArticleSavedUseCase(article.id);
        return article;
      }).toList();
    } catch (error) {
      // في حالة الخطأ، نعيد رميه ليقوم PagingController بمعالجته
      rethrow;
    }
  }

  void changeCategory(String category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;

    // لإعادة تحميل البيانات من البداية
    pagingController.refresh();
  }

  Future<void> onArticleBookmarkPressed(Article pressedArticle) async {
    final isSavedNow = await _toggleBookmarkUseCase.call(
      article: pressedArticle,
    );

    // Modifying its 'isSaved' property directly updates the instance stored in the
    // pagingController's internal list, ensuring data consistency without redundant loops.
    pressedArticle.isSaved = isSavedNow;

    update([(pressedArticle.id)]);
  }

  void onRefreshPressed() {
    pagingController.refresh();
  }

  void onArticleCardPressed(Article article) {
    // Navigation Logic
  }

  @override
  void onClose() {
    searchFocusNode.dispose();
    pagingController.dispose();
    _bookmarksSubscription?.cancel();
    super.onClose();
  }
}
