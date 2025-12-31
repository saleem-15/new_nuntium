import 'package:get/get.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/routes/routes.dart';

class SelectFavoriteTopicsController extends GetxController {
  final List<String> topics = [
    AppStrings.sports,
    AppStrings.politics,
    AppStrings.life,
    AppStrings.gaming,
    AppStrings.animals,
    AppStrings.nature,
    AppStrings.food,
    AppStrings.art,
    AppStrings.history,
    AppStrings.fashion,
  ];

  final selectedTopics = <String>[];

  void toggleTopic(String topic) {
    if (selectedTopics.contains(topic)) {
      selectedTopics.remove(topic);
    } else {
      selectedTopics.add(topic);
    }
    update([topic]);
  }

  void onNextPressed() {
    Get.offNamed(Routes.homeView);
  }
}
