import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/routes/routes.dart';

class SignUpController extends GetxController {
  late TextEditingController userNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController repeatPasswordController;

  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;
  bool isPasswordEmpty = true;

  @override
  void onInit() {
    super.onInit();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    repeatPasswordController = TextEditingController();

    // listen to the changes in the password field
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
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();

    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  void login() {
    // if the data is correct
    if (signUpFormKey.currentState!.validate()) {
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

  void onSignUpPressed() {}

  void onSignInPressed() {
    Get.offNamed(Routes.loginView);
  }
}
