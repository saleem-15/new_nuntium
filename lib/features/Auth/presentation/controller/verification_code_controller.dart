import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationCodeController extends GetxController {
  late TextEditingController otpController;

  @override
  void onInit() {
    otpController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }

  void onconfirmPressed() {}

  void onTryAgainPressed() {}
}
