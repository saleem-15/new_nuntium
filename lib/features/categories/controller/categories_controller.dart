import 'package:get/get.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';

class CategoriesController extends GetxController {
  var isLoading = false.obs;

  final categories = [
    AppStrings.sportsWithEmoji,
    AppStrings.politicsWithEmoji,
    AppStrings.lifeWithEmoji,
    AppStrings.gamingWithEmoji,
    AppStrings.animalsWithEmoji,
    AppStrings.natureWithEmoji,
    AppStrings.foodWithEmoji,
    AppStrings.artWithEmoji,
    AppStrings.historyWithEmoji,
    AppStrings.fashionWithEmoji,
  ].obs;

  // هذه الدالة التي سنستدعيها من الخارج
  void fetchCategoriesIfNeeded() {
    // إذا كانت القائمة ممتلئة، لا تجلب البيانات مرة أخرى (Cache)
    if (categories.isNotEmpty) return;

    // إذا كانت فارغة، ابدأ الجلب
    fetchCategories();
  }

  void fetchCategories() async {
    isLoading.value = true;
    // ... كود الـ HTTP Request ...
    isLoading.value = false;
  }

  void onCategoryPressed() {}
}
