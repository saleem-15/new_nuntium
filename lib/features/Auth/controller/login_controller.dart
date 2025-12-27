import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  // 2. مفتاح للـ Form للقيام بالـ Validation
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;
  bool isPasswordEmpty = true;

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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  void login() {
    // if the data is correct
    if (loginFormKey.currentState!.validate()) {
      // Get.offAllNamed(Routes.HOME);
    }
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

  // مراجعة التحقق من كلمة المرور
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  void onForgetPasswordPressed() {}

  void onSignInPressed() {}

  void onSignInWithGooglePressed() {}

  void onSignUpPressed() {}

  void onSignInWithFacebookPressed() {}
}
