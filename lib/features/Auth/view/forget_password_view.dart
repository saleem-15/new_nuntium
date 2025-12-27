import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/widgets/custom_rich_text.dart';
import 'package:new_nuntium/core/widgets/custom_text_field.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:new_nuntium/features/Auth/controller/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({super.key});

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
                AppStrings.forgetPasswordTitle,
                style: context.headline1,
                textAlign: TextAlign.left,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              AppStrings.forgetPasswordSubTitle,
              style: context.body1,
            ),

            SizedBox(height: 32.h),

            //Email Field
            CustomTextField(
              controller: controller.emailController,
              hintText: AppStrings.emailAdress,
              prefixIcon: Icons.email_outlined,
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
