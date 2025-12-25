import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:new_nuntium/core/constants/app_assets.dart';
import 'package:new_nuntium/core/resources/manager_fonts.dart';
import 'package:new_nuntium/core/resources/manager_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:new_nuntium/features/onboarding/controller/onboarding_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 120.h),
          CarouselSlider(
            options: CarouselOptions(
              height: 340.h,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: .75,
              onPageChanged: controller.animateSliderIndicator,
            ),

            items: [
              Image.asset(ManagerAssets.onboarding),
              Image.asset(ManagerAssets.onboarding),
              Image.asset(ManagerAssets.onboarding),
            ],
          ),
          SizedBox(height: 40.h),
          GetBuilder<OnboardingController>(
            builder: (context) {
              return AnimatedSmoothIndicator(
                count: 3,
                activeIndex: controller.carouselIndex,
                effect: ExpandingDotsEffect(
                  dotColor: ManagerColors.greyLighter,
                  activeDotColor: ManagerColors.purplePrimary,
                  dotHeight: 8.sp,
                  dotWidth: 8.sp,
                ),
              );
            },
          ),
          SizedBox(height: 34.h),
          Text(
            ManagerStrings.firstToKnow,
            style: TextStyle(
              fontFamily: ManagerFontFamily.fontFamily,
              fontWeight: ManagerFontWeight.semiBold,
              fontSize: 24.sp,
              color: ManagerColors.blackPrimary,
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: 216.w,
            height: 48.h,
            child: Text(
              ManagerStrings.onboardingDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: ManagerFontFamily.fontFamily,
                fontWeight: ManagerFontWeight.regular,
                fontSize: 16.sp,
                color: ManagerColors.greyPrimary,
              ),
            ),
          ),

          SizedBox(height: 64.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: PrimaryButton(text: 'Next', onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
