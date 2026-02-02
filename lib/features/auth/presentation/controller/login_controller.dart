import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/config/routes.dart';
import 'package:new_nuntium/core/widgets/error_snack_bar.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';

import '../../domain/use_cases/login_use_case.dart';

class LoginController extends GetxController {
  // --- Dependencies ---
  final _signInUseCase = getIt<LoginUseCase>();
  final _signInWithGoogleUseCase = getIt<SignInWithGoogleUseCase>();

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

    final result = await _signInUseCase.call(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    result.fold(
      (failure) => showErrorSnackBar(failure.message),

      (right) => Get.offAllNamed(Routes.mainView),
    );

    isLoading.value = false;
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
    final result = await _signInWithGoogleUseCase.call();

    result.fold(
      (failure) => showErrorSnackBar(failure.message),
      (right) => Get.offAllNamed(Routes.mainView),
    );

    // Get.snackbar(AppStrings.googleSignInFailed, e.toString());
  }

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
