import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/config/routes.dart';
import 'package:new_nuntium/core/constants/constanst.dart';
import 'package:new_nuntium/core/utils/app_validator.dart';
import 'package:new_nuntium/core/widgets/error_snack_bar.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/reset_password.dart';

import '../view/widgets/email_link_is_sent_dialog.dart';
import 'resend_time_controller.dart';

class ForgetPasswordController extends GetxController {
  late TextEditingController emailController;
  final _resetPasswordUseCase = getIt<ResetPasswordUseCase>();

  @override
  void onInit() {
    emailController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> onNextPressed() async {
    final email = emailController.text.trim();
    final validateEmail = AppValidator.validateEmail(email);

    //check if valid email
    if (validateEmail != null) {
      showErrorSnackBar(validateEmail);
      return;
    }

    _sendEmail(email);
  }

  Future<void> _sendEmail(String email) async {
    try {
      await _resetPasswordUseCase.call(email);
      showSuccessDialog(
        email,
        reSendEmail: _sendEmail,
        timerController: Get.find<ResendTimerController>(
          tag: Constants.resendDialogControllerId,
        ),
      );
    } on Exception catch (e) {
      showErrorSnackBar(e.toString());
    }
  }

  void onTryAgainPressed() {
    Get.offAllNamed(Routes.loginView);
  }
}
