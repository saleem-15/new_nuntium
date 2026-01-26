import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/config/routes.dart';
import 'package:new_nuntium/core/errors/app_exception.dart';

import '../../domain/use_cases/login_use_case.dart';

class LoginController extends GetxController {
  // --- Dependencies ---
  final _loginUseCase = getIt<LoginUseCase>();

  // --- UI Controllers & State ---
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isPasswordHidden = true;
  bool isPasswordEmpty = true;
  RxBool isLoading = true.obs;

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

  Future<void> login() async {
    // 1. التحقق من صحة المدخلات قبل إرسال الطلب
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      // 2. استدعاء UseCase (طبقة الـ Domain)
      await _loginUseCase.call(
        emailController.text.trim(),
        passwordController.text,
      );

      // 3. النجاح: الانتقال إلى الصفحة الرئيسية وحذف الصفحات السابقة من الذاكرة
      Get.offAllNamed(Routes.mainView);
    } catch (e) {
      // 4. الفشل: التعامل مع الأخطاء وعرض رسالة للمستخدم
      String message = "unknown_error"; // مفتاح احتياطي

      if (e is AppException) {
        message = e.messageKey; // استخدام المفتاح القادم من طبقة البيانات
      } else {
        // طباعة الخطأ في الكونسول للمساعدة في التطوير
        debugPrint("Login Error: $e");
      }

      // عرض التنبيه (تأكد من استخدام .tr() للترجمة)
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

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    if (!GetUtils.isEmail(value)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  void onForgetPasswordPressed() {
    Get.toNamed(Routes.forgetPasswordView);
  }

  void onSignInPressed() {}

  void onSignInWithGooglePressed() {}

  void onSignUpPressed() {
    Get.offNamed(Routes.signUpView);
  }

  void onSignInWithFacebookPressed() {}

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
