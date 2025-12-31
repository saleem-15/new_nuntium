import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/features/bookmarks/bookmarks_controller.dart';
import 'package:new_nuntium/features/bookmarks/bookmarks_view.dart';
import 'package:new_nuntium/features/categories/controller/categories_controller.dart';
import 'package:new_nuntium/features/categories/views/categories_view.dart';
import 'package:new_nuntium/features/home/controller/home_page._controller.dart';
import 'package:new_nuntium/features/home/view/home_page.dart';

class MainController extends GetxController {
  var currentPageIndex = 0.obs;

  final List<Widget> pages = [
    const HomeView(),
    const CategoriesView(),
    const BookmarksView(),
    // const ProfileView(),
  ];

  @override
  void onInit() {
    super.onInit();
    //the Home screen always will opened, So its data must be fetched
    Get.find<HomeController>().fetchData();
  }

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
