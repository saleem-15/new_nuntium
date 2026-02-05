import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/features/bookmarks/presentation/controller/bookmarks_controller.dart';
import 'package:new_nuntium/features/bookmarks/presentation/view/bookmarks_view.dart';
import 'package:new_nuntium/features/categories/presentation/controller/categories_controller.dart';
import 'package:new_nuntium/features/categories/presentation/views/categories_view.dart';
import 'package:new_nuntium/features/home/presentation/view/home_page.dart';

class MainController extends GetxController {
  var currentPageIndex = 0.obs;

  final List<Widget> pages = [
    const HomeView(),
    const CategoriesView(),
    const BookmarksView(),
    // const ProfileView(),
  ];

  void changePage(int index) {
    currentPageIndex.value = index;

    // المنطق الذكي: بناءً على الفهرس، نطلب من الكنترولر جلب البيانات
    switch (index) {
      case 1: // Categories
        // نستخدم find لجلب الكنترولر، ثم نأمره بالجلب إذا لزم الأمر
        Get.find<CategoriesController>().fetchCategoriesIfNeeded();
        break;

      case 2: // Bookmarks
        // نستخدم find لجلب الكنترولر، ثم نأمره بالجلب إذا لزم الأمر
        Get.find<BookmarksController>().fetchBookmarksIfNeeded();
        break;
    }
  }

  /// Called when the tab changes, useful for fetching data on demand
  void onNavigationBarItemTapped(int index) {
    // Logic to fetch data for the selected tab
    log("Selected tab: $index");
  }
}
