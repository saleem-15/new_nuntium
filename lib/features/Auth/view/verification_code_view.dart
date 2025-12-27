import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/widgets/custom_rich_text.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:new_nuntium/features/Auth/controller/verification_code_controller.dart';
import 'package:pinput/pinput.dart';

class VerificationCodeView
    extends GetView<VerificationCodeController> {
  const VerificationCodeView({super.key});

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
                AppStrings.verificatonCodeTitle,
                style: context.headline1,
                textAlign: TextAlign.left,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              AppStrings.verificatonCodeSubTitle,
              style: context.body1,
            ),

            SizedBox(height: 32.h),
            Pinput(
              controller: controller.otpController,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              defaultPinTheme: PinTheme(
                width: 72.w,
                height: 72.w,
                textStyle: TextStyle(
                  fontSize: 20.sp,
                  color: AppColors.blackPrimary,
                  fontWeight: AppFonts.semiBold,
                ),
                decoration: BoxDecoration(
                  color: AppColors.greyLighter,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),

              focusedPinTheme: PinTheme(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.purplePrimary),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            PrimaryButton(
              text: AppStrings.confirm,
              onPressed: controller.onconfirmPressed,
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
