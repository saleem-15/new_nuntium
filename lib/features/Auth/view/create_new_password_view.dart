import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/widgets/custom_rich_text.dart';
import 'package:new_nuntium/core/widgets/custom_text_field.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:new_nuntium/features/Auth/controller/create_new_password_controller.dart';

class CreateNewPasswordView
    extends GetView<CreateNewPasswordController> {
  const CreateNewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: 72.h,
          bottom: 20.h,
          right: 20.w,
          left: 20.w,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.createNewPasswordTitle,
                style: context.headline1,
                textAlign: TextAlign.left,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              AppStrings.createNewPasswordSubTitle,
              style: context.body1,
            ),

            SizedBox(height: 32.h),

            CustomTextField(
              controller: controller.newPasswordController,
              hintText: AppStrings.newPassword,
              prefixIcon: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
            ),

            SizedBox(height: 16.h),

            CustomTextField(
              controller: controller.repeatedNewPasswordController,
              hintText: AppStrings.repeateNewPassword,
              prefixIcon: Icons.lock_outline,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),

            SizedBox(height: 16.h),

            PrimaryButton(
              text: AppStrings.confirm,
              onPressed: controller.onConfirmPressed,
            ),

            Spacer(),

            CustomRichText(
              firstText: AppStrings.didntReciveEmail,
              secondText: AppStrings.sendAgain,
              onTap: controller.onTryAgainPressed,
            ),
          ],
        ),
      ),
    );
  }
}
