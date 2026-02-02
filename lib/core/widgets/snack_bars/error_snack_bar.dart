import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackBar(String message, {String? title}) {
  Get.rawSnackbar(
    title: title,
    message: message,
    backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
    snackPosition: SnackPosition.BOTTOM,
  );
}
