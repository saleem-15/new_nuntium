import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateNewPasswordController extends GetxController {
  late TextEditingController newPasswordController;
  late TextEditingController repeatedNewPasswordController;

  @override
  void onInit() {
    newPasswordController = TextEditingController();
    repeatedNewPasswordController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    repeatedNewPasswordController.dispose();
    super.onClose();
  }

  void onConfirmPressed() {}

  void onTryAgainPressed() {}

  void changePassword() {}
  void toggleRepeatPasswordVisibility() {}
}
