import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/config/routes.dart';
import 'package:new_nuntium/core/constants/get_builders_ids.dart';
import 'package:new_nuntium/core/widgets/snack_bars/error_snack_bar.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:new_nuntium/features/profile/view/widgets/sign_out_dialog.dart';

class ProfileController extends GetxController {
  final _signOutUseCase = getIt<SignOutUseCase>();

  bool isNotificationsOn = true;

  String userName = 'Eren Turkmen';

  String userEmail = 'ertasfsdfadfsuken@gmail.com';

  ImageProvider<Object>? userImage = NetworkImage(
    'https://media.istockphoto.com/id/1309328823/photo/headshot-portrait-of-smiling-male-employee-in-office.jpg?s=612x612&w=0&k=20&c=kPvoBm6qCYzQXMAn9JUtqLREXe9-PlZyMl9i-ibaVuY=',
  );

  void toggleNotifications(bool value) {
    isNotificationsOn = value;
    update([AppGetBuildersIds.notificationsSwitch]);
  }

  void onLanguagePressed() {
    Get.toNamed(Routes.languageView);
  }

  void onChangePasswordPressed() {
    Get.toNamed(Routes.changePasswordView);
  }

  void onPrivacyPressed() {
    Get.toNamed(Routes.privacyAndPolicyView);
  }

  void onTermsAndConditionsPressed() {
    Get.toNamed(Routes.termsAndConditionsView);
  }

  void onSignOutPressed() {
    showSignoutDialog(onSignOutPressed: _performSignOut);
  }

  Future<void> _performSignOut() async {
    //close dialog
    Get.back();

    final result = await _signOutUseCase.call();

    result.fold(
      (failure) => showErrorSnackBar(failure.message),
      (right) => Get.offAllNamed(Routes.loginView),
    );
  }
}
