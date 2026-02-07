import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/config/routes.dart';
import 'package:new_nuntium/core/constants/get_builders_ids.dart';
import 'package:new_nuntium/core/widgets/snack_bars/error_snack_bar.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:new_nuntium/features/profile/domain/use_cases/get_user_data_use_case.dart';
import 'package:new_nuntium/features/profile/presentation/view/widgets/sign_out_dialog.dart';

import '../../domain/entities/user_entity.dart';

class ProfileController extends GetxController {
  final _signOutUseCase = getIt<SignOutUseCase>();
  final _getUserDataUseCase = getIt<GetUserDataUseCase>();

  UserEntity? user;

  bool isNotificationsOn = true;

  ImageProvider<Object>? get image {
    if (user != null && user?.photoUrl != null) {
      return NetworkImage(user!.photoUrl!);
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  void getUserData() {
    final result = _getUserDataUseCase.call();

    result.fold((failure) {}, (userEntity) {
      user = userEntity;
    });
  }

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
