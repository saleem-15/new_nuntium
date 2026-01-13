import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';

class LanguageController extends GetxController {
  final languages = [AppStrings.english];

  void onBackButtonPressed() {
    Get.back();
  }
}
