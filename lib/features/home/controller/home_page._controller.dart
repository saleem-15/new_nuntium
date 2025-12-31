import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/features/home/data/news_model.dart';

class HomeController extends GetxController {
  late FocusNode searchFocusNode;
  final isSearchFocused = false.obs;

  // قائمة الفئات (يفضل وضعها في AppStrings)
  final List<String> categories = [
    "Random",
    "Sports",
    "Gaming",
    "Politics",
    "Life",
    "Animals",
  ];

  List<News> recentNews = [
    News(
      id: '1',
      category: 'POLITICS',
      title: 'The latest situation in the presidential election',
      imageUrl:
          'https://travel.usnews.com/dims4/USNEWS/cf429aa/2147483647/resize/976x652%5E%3E/crop/976x652/quality/85/format/webp/?url=https%3A%2F%2Ftravel.usnews.com%2Fimages%2FCapitol1_Getty.jpg',
    ),
    News(
      id: '2',
      category: 'ART',
      title: 'An updated daily front page',
      imageUrl:
          'https://www.edenart.com/_next/image?url=https%3A%2F%2Fsrv-1.eden-gallery.com%2F2021%2F08%2F11%2F6113d70d63ca0-What-is-Fine-Art--Eden-Gallery-.jpeg&w=1920&q=75',
    ),
  ];

  final List<News> recommendedNews = [
    News(
      id: '3',
      category: 'Sports',
      title: 'The impact of technology on modern football',
      imageUrl:
          'https://www.newsclick.in/sites/default/files/styles/responsive_885/public/2018-07/N%27Golo%20Kante%20and%20Lionel%20Messi.jpg',
    ),
    News(
      id: '4',
      category: 'Gaming',
      title: 'Next-gen consoles: What to expect in 2026',
      imageUrl:
          'https://cdn.thewirecutter.com/wp-content/media/2023/05/gamingconsoles-2048px-00730-3x2-1.jpg?auto=webp&quality=75&width=980&dpr=2',
    ),
  ];

  var selectedCategory = "Random".obs;

  @override
  void onInit() {
    super.onInit();
    searchFocusNode = FocusNode();

    // focus node إضافة مستمع لتغير حالة
    searchFocusNode.addListener(() {
      isSearchFocused.value = searchFocusNode.hasFocus;
    });
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    // هنا سنستدعي لاحقاً دالة جلب الأخبار بناءً على الفئة
    // fetchNewsByCategory(category);
  }

  @override
  void onClose() {
    searchFocusNode.dispose();
    super.onClose();
  }

  void onNewsCardPressed(News pressedNews) {}

  void onNewsCardBookmarkPressed(News pressedNews) {
    pressedNews.isSaved = !pressedNews.isSaved;

    update([pressedNews.id]);
  }

  void fetchData() {}
}
