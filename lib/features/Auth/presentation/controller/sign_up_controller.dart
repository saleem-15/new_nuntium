import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/config/routes.dart';
import 'package:new_nuntium/core/errors/app_exception.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/signup_use_case.dart';

class SignUpController extends GetxController {
  // --- Dependencies ---
  final _signupUseCase = getIt<SignupUseCase>();

  late TextEditingController userNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController repeatPasswordController;

  final formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;
  bool isPasswordEmpty = true;
  RxBool isLoading = true.obs;

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

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  void login() {
    // if the data is correct
    if (formKey.currentState!.validate()) {
      // Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> signUp() async {
    // Validate the inputs
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      await _signupUseCase.call(
        emailController.text.trim(),
        passwordController.text.trim(),
        userNameController.text.trim(),
      );

      Get.offAllNamed(Routes.mainView);
    } catch (e) {
      String message = "unknown_error"; // مفتاح احتياطي

      if (e is AppException) {
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

  void onSignInPressed() {
    Get.offNamed(Routes.loginView);
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

  String? validateRepeatPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please re-enter your password";
    }
    if (passwordController.text.trim() !=
        repeatPasswordController.text.trim()) {
      return "Passwords do not match";
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }

    // Length validation
    if (value.length < 3 || value.length > 15) {
      return 'Username must be between 3 and 15 characters';
    }

    // Regex validation: Starts with a letter, allows letters, numbers, and underscores
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Only letters, numbers, and underscores allowed (must start with a letter)';
    }

    return null; // Return null if the input is valid
  }

  @override
  void onClose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();

    super.onClose();
  }
}
