import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/config/routes.dart';
import 'package:new_nuntium/core/errors/app_exception.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/sign_in_with_facebook_use_case.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';

import '../../domain/use_cases/login_use_case.dart';

class LoginController extends GetxController {
  // --- Dependencies ---
  final _loginUseCase = getIt<LoginUseCase>();
  final _signInWithGoogleUseCase = getIt<SignInWithGoogleUseCase>();
  final _signInWithFacebookleUseCase = getIt<SignInWithFacebookUseCase>();

  // --- UI Controllers & State ---
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isPasswordHidden = true;
  bool isPasswordEmpty = true;
  RxBool isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    // الاستماع للتغييرات في حقل كلمة المرور
    passwordController.addListener(() {
      bool isEmpty = passwordController.text.isEmpty;
      if (isPasswordEmpty != isEmpty) {
        isPasswordEmpty = isEmpty;
        update();
      }
    });
  }

  Future<void> _signIn() async {
    isLoading.value = true;

    try {
      await _loginUseCase.call(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      Get.offAllNamed(Routes.mainView);
    } catch (e) {
      String message = "unknown_error"; // مفتاح احتياطي

      if (e is AppException) {
        // استخدام المفتاح القادم من طبقة البيانات
        message = e.messageKey;
      } else {
        debugPrint("Login Error: $e");
      }

      Get.snackbar(
        "error",
        message,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  void onForgetPasswordPressed() {
    Get.toNamed(Routes.forgetPasswordView);
  }

  void onSignInPressed() {
    // Validate the inputs before sending the request
    if (!formKey.currentState!.validate()) {
      return;
    }
    _signIn();
  }

  Future<void> onSignInWithGooglePressed() async {
    try {
      await _signInWithGoogleUseCase.call();

      Get.offAllNamed(Routes.mainView);
    } catch (e) {
      log(e.toString());
    }
  }

  void onSignUpPressed() {
    Get.offNamed(Routes.signUpView);
  }

  Future<void> onSignInWithFacebookPressed() async {
    try {
      await _signInWithFacebookleUseCase.call();
      

      Get.offAllNamed(Routes.mainView);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
