import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/core/constants/get_builders_ids.dart';
import 'package:new_nuntium/core/widgets/error_snack_bar.dart';

import '../../domain/use_cases/change_password_use_case.dart';

class ChangePasswordController extends GetxController {
  final _changePasswordUseCase = getIt<ChangePasswordUseCase>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController currentPasswordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController repeatPasswordController;

  // 3 متغيرات لإخفاء/إظهار النصوص
  bool isCurrentHidden = true;
  bool isNewHidden = true;
  bool isRepeatHidden = true; // دائماً true لأنك لا تريد أيقونة هنا

  bool isCurrentPasswordEmpty = true;
  bool isNewPasswordEmpty = true;

  late final FocusNode currentPasswordFocus;
  late final FocusNode newPasswordFocus;
  late final FocusNode repeatPasswordFocus;

  var isLoading = false;

  @override
  void onInit() {
    super.onInit();

    // 2. تهيئة FocusNodes
    currentPasswordFocus = FocusNode();
    newPasswordFocus = FocusNode();
    repeatPasswordFocus = FocusNode();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    repeatPasswordController = TextEditingController();

    // إضافة مستمعين لتحديث حالة "الحقل فارغ"
    currentPasswordController.addListener(() {
      final isEmpty = currentPasswordController.text.isEmpty;
      if (isCurrentPasswordEmpty != isEmpty) {
        isCurrentPasswordEmpty = isEmpty;
        update([AppGetBuildersIds.changePasswordCurrentVisibility]);
      }
    });

    newPasswordController.addListener(() {
      final isEmpty = newPasswordController.text.isEmpty;
      if (isNewPasswordEmpty != isEmpty) {
        isNewPasswordEmpty = isEmpty;
        update([AppGetBuildersIds.changePasswordNewVisibility]);
      }
    });
  }

  void toggleCurrentVisibility() {
    isCurrentHidden = !isCurrentHidden;
    update([AppGetBuildersIds.changePasswordCurrentVisibility]);
  }

  void toggleNewVisibility() {
    isNewHidden = !isNewHidden;
    update([AppGetBuildersIds.changePasswordNewVisibility]);
  }

  void updatePassword() async {
    // if fields values are not valid then dont continue
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading = true;
    update([AppGetBuildersIds.changePasswordButton]);

    final result = await _changePasswordUseCase.call(
      currentPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
    );

    isLoading = false;
    update([AppGetBuildersIds.changePasswordButton]);

    result.fold((failure) => showErrorSnackBar(failure.message), (success) {
      Get.back();
      Get.snackbar(
        'done', // تأكد أن لديك نص "Done" أو "Success"
        "Password updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    });
  }

  // Future<void> updatePassword() async {
  //   if (formKey.currentState!.validate()) {
  //     // هنا تضع لوجيك الاتصال بالـ API
  //     // await repository.updatePassword(...);

  //     Get.back(); // العودة للبروفايل
  //     Get.snackbar("Success", "Password updated successfully");
  //   }
  // }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    repeatPasswordController.dispose();

    currentPasswordFocus.dispose();
    newPasswordFocus.dispose();
    repeatPasswordFocus.dispose();
    super.onClose();
  }
}
