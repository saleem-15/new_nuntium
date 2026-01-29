import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:new_nuntium/core/constants/app_assets.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:new_nuntium/features/onboarding/controller/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 170.h),
          Image.asset(
            AppAssets.illustration,
            fit: BoxFit.fitWidth,
            width: double.infinity,
          ),
          SizedBox(height: 60.h),
          Text(
            AppStrings.nuntium,
            style: context.headline1.copyWith(fontSize: 34.sp),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: 260.w,
            child: Text(
              AppStrings.welcomeBody,
              textAlign: TextAlign.center,
              style: context.body1,
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(
              right: 20.w,
              left: 20.w,
              bottom: 35.h,
            ),
            child: PrimaryButton(
              text: AppStrings.getStarted,
              onPressed: controller.onButtonPressed,
            ),
          ),
        ],
      ),
    );
  }
}
