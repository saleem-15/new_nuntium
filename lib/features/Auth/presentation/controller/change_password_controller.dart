import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';

class ChangePasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // نحتاج 3 حقول نصية
  late final TextEditingController currentPasswordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController repeatPasswordController;

  // 3 متغيرات لإخفاء/إظهار النصوص
  var isCurrentHidden = true.obs;
  var isNewHidden = true.obs;
  var isRepeatHidden = true.obs;

  @override
  void onInit() {
    super.onInit();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    repeatPasswordController = TextEditingController();
  }

  // دوال التبديل (Toggle)
  void toggleCurrentVisibility() =>
      isCurrentHidden.value = !isCurrentHidden.value;
  void toggleNewVisibility() => isNewHidden.value = !isNewHidden.value;
  void toggleRepeatVisibility() => isRepeatHidden.value = !isRepeatHidden.value;

  Future<void> updatePassword() async {
    if (formKey.currentState!.validate()) {
      // هنا تضع لوجيك الاتصال بالـ API
      // await repository.updatePassword(...);

      Get.back(); // العودة للبروفايل
      Get.snackbar("Success", "Password updated successfully");
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    repeatPasswordController.dispose();
    super.onClose();
  }

  String? validatePassword(String? val) {
    if (val != newPasswordController.text) {
      return AppStrings.passwordsDontMatch;
    }
    return null;
  }
}
