import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:new_nuntium/core/resources/app_assets.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/widgets/custom_rich_text.dart';
import 'package:new_nuntium/core/widgets/custom_text_field.dart';
import 'package:new_nuntium/core/widgets/header.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:new_nuntium/features/auth/presentation/controller/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: 20.h, right: 20.w, left: 20.w),
        child: Column(
          children: [
            Header(
              title: AppStrings.forgetPasswordTitle,
              subTtitle: AppStrings.forgetPasswordSubTitle,
            ),
            //Email Field
            CustomTextField(
              controller: controller.emailController,
              hintText: AppStrings.emailAdress,
              prefixIcon: AppIcons.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),

            SizedBox(height: 16.h),

            PrimaryButton(
              text: AppStrings.next,
              onPressed: controller.onNextPressed,
            ),

            Spacer(),

            CustomRichText(
              firstText: AppStrings.remmeberPassword,
              secondText: AppStrings.tryAgain,
              onTap: controller.onTryAgainPressed,
            ),
          ],
        ),
      ),
    );
  }
}
