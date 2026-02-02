import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/config/routes.dart';
import 'package:new_nuntium/core/widgets/error_snack_bar.dart';
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
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    repeatPasswordController = TextEditingController();

    _listenToPasswordFieldChanges();
  }

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    update();
  }

  Future<void> onSignUpPressed() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    await _signUp();
  }

  Future<void> _signUp() async {
    isLoading.value = true;

    final result = await _signupUseCase.call(
      emailController.text.trim(),
      passwordController.text.trim(),
      userNameController.text.trim(),
    );

    result.fold(
      (failure) => showErrorSnackBar(failure.message),

      (right) => Get.offAllNamed(Routes.mainView),
    );

    isLoading.value = false;

    // try {
    //   await _signupUseCase.call(
    //     emailController.text.trim(),
    //     passwordController.text.trim(),
    //     userNameController.text.trim(),
    //   );

    //   Get.offAllNamed(Routes.mainView);
    // } catch (e) {
    //   String message = "unknown_error"; // مفتاح احتياطي

    //   if (e is AppException) {
    //     message = e.messageKey;
    //   } else {
    //     log("Login Error: $e");
    //   }

    //   log("Login Error: $e");
    //   Get.snackbar(
    //     "error",
    //     message,
    //     backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
    //     colorText: Colors.white,
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // } finally {
    //   isLoading.value = false;
    // }
  }

  void onSignInPressed() {
    Get.offNamed(Routes.loginView);
  }

  /// listen to the changes in the password field
  /// useful for showing/hiding password icon
  void _listenToPasswordFieldChanges() {
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
}
