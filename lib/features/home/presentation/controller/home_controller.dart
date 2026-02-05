import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/config/routes.dart';
import 'package:new_nuntium/core/errors/failures.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/features/bookmarks/domain/entity/bookmark_event.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/check_if_saved_use_case.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/watch_bookmarks_changes_use_case.dart';
import 'package:new_nuntium/features/categories/domain/use_case/get_cateogories_use_case.dart';
import 'package:new_nuntium/features/home/domain/use_cases/fetch_news_use_case.dart';
import 'package:new_nuntium/features/home/domain/use_cases/toggle_bookmark_use_case.dart';

import '../../../categories/domain/entities/category_entity.dart';
import '../../domain/use_cases/search_news_use_case.dart';

class HomeController extends GetxController {
  // ---Dependencies---
  final _fetchNewsUseCase = getIt<FetchNewsUseCase>();
  final _searchNewsUseCase = getIt<SearchNewsUseCase>();
  final _getCategoriesUseCase = getIt<GetCategoriesUseCase>();

  // Bookmark Use Cases
  final _checkIfArticleSavedUseCase = getIt<CheckIfSavedUseCase>();
  final _toggleBookmarkUseCase = getIt<ToggleBookmarkUseCase>();
  final _watchBookmarksUseCase = getIt<WatchBookmarksChangesUseCase>();
  StreamSubscription? _bookmarksSubscription;

  // ---UI State---
  late FocusNode searchFocusNode;
  final isSearchFieldFocused = false.obs;

  late final Rx<CategoryEntity> selectedCategory;

  late List<CategoryEntity> categories;

  late final PagingController<int, Article> pagingController;
  static const int _pageSize = 20;

  late ScrollController scrollController;
  late final TextEditingController searchFieldController;
  String get _searchQuery => searchFieldController.text.trim();

  var showScrollUpButton = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCategoriesList(isFirstLoad: true);

    searchFocusNode = FocusNode();
    searchFieldController = TextEditingController();

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

    scrollController = ScrollController();
    _listenToScrollPosition();
  }

  void _listenToScrollPosition() {
    scrollController.addListener(() {
      // إذا نزل المستخدم أكثر من 400 بيكسل، نظهر الزر
      if (scrollController.offset >= 400) {
        if (!showScrollUpButton.value) showScrollUpButton.value = true;
      } else {
        if (showScrollUpButton.value) showScrollUpButton.value = false;
      }
    });
  }

  Future<void> getCategoriesList({bool isFirstLoad = false}) async {
    // 2. استخدام await هنا لانتظار النتيجة الفعلية
    final result = await _getCategoriesUseCase.call();
    result.fold((failure) {}, (result) {
      categories = result;

      if (isFirstLoad) {
        selectedCategory = categories.first.obs;

        return;
      }

      // Update the selected category
      final currentCategoryId = selectedCategory.value.id;

      final updatedSelectedItem = categories.firstWhere(
        (c) => c.id == currentCategoryId,
        orElse: () => categories.first,
      );

      selectedCategory.value = updatedSelectedItem;
    });
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

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  ///  fetch Articles for (Search) or (Category) based on input
  Future<List<Article>> _fetchArticles(int pageKey) async {
    final isSearching = _searchQuery.isNotEmpty;

    final Either<Failure, List<Article>> result;

    if (isSearching) {
      // 1. If user is searching, use the Search UseCase
      result = await _searchNewsUseCase.call(
        query: _searchQuery,
        page: pageKey,
        pageSize: _pageSize,
      );
    } else {
      // 2. If search is empty, use the existing Category UseCase
      String? categoryParam = selectedCategory.value.id;

      result = await _fetchNewsUseCase(
        category: categoryParam,
        page: pageKey,
        pageSize: _pageSize,
      );
    }

    return result.fold(
      (failure) {
        throw Exception(failure.message);
      },
      (newArticles) {
        return newArticles.map((article) {
          article.isSaved = _checkIfArticleSavedUseCase(article.id);
          return article;
        }).toList();
      },
    );
  }

  // Update changeCategory to clear search when switching categories
  void changeCategory(CategoryEntity category) {
    if (selectedCategory.value == category) return;

    //  Clear search when changing category
    searchFieldController.clear();

    selectedCategory.value = category;
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
    Get.toNamed(Routes.articleView, arguments: article);
  }

  @override
  void onClose() {
    searchFocusNode.dispose();
    pagingController.dispose();
    _bookmarksSubscription?.cancel();
    scrollController.dispose();

    super.onClose();
  }

  void search() {
    pagingController.refresh();
    searchFocusNode.unfocus();
  }
}
