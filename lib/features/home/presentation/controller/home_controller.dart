import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/check_if_saved_use_case.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/delete_bookmark_use_case.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/save_bookmark_use_case.dart';
import 'package:new_nuntium/features/home/domain/use_cases/fetch_news_use_case.dart';

class HomeController extends GetxController {
  // ---Dependencies---
  final _fetchNewsUseCase = getIt<FetchNewsUseCase>();

  // Bookmark Use Cases
  final _saveBookmarkUseCase = getIt<SaveBookmarkUseCase>();
  final _deleteBookmarkUseCase = getIt<DeleteBookmarkUseCase>();
  final _checkIfArticleSavedUseCase = getIt<CheckIfSavedUseCase>();

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
    // تبديل حالة الحفظ في التخزين
    if (pressedArticle.isSaved) {
      await _deleteBookmarkUseCase(pressedArticle.id);
    } else {
      await _saveBookmarkUseCase(pressedArticle);
    }

    // في الإصدار 5، نستخدم mapItems لتحديث عنصر داخل القائمة دون إعادة تحميلها
    pagingController.mapItems((article) {
      if (article.id == pressedArticle.id) {
        // نُرجع نسخة محدثة من المقال
        // (ملاحظة: بما أن Article هو HiveObject، التعديل المباشر قد يعمل،
        // لكن الأفضل إنشاء نسخة جديدة أو تعديل الخاصية وإرجاع الكائن)
        article.isSaved = !pressedArticle.isSaved;
        return article;
      }
      return article;
    });
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
    super.onClose();
  }
}
