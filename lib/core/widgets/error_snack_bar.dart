import 'package:get/get.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';

void showErrorSnackBar(String message) {
  Get.snackbar(AppStrings.error, message, snackPosition: SnackPosition.BOTTOM);
}
