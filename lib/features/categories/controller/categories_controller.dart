import 'package:get/get.dart';

class CategoriesController extends GetxController {
  var categories = <String>[].obs;
  var isLoading = false.obs;

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
