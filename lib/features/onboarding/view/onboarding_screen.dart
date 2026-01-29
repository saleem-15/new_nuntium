import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:new_nuntium/core/constants/app_assets.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
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
            carouselController: controller.carouselSliderController,
            options: CarouselOptions(
              height: 336.h,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.zoom,
              autoPlay: true,
              reverse: false,
              autoPlayInterval: const Duration(seconds: 4),
              enableInfiniteScroll: true,
              onPageChanged: controller.onSliderChanged,
            ),
            items: [
              Image.asset(AppAssets.onboarding),
              Image.asset(AppAssets.onboarding),
              Image.asset(AppAssets.onboarding),
            ],
          ),
          SizedBox(height: 40.h),
          GetBuilder<OnboardingController>(
            builder: (context) {
              return AnimatedSmoothIndicator(
                count: 3,
                activeIndex: controller.carouselIndex,
                effect: ExpandingDotsEffect(
                  dotColor: AppColors.greyLighter,
                  activeDotColor: AppColors.purplePrimary,
                  dotHeight: 8.sp,
                  dotWidth: 8.sp,
                ),
              );
            },
          ),
          SizedBox(height: 34.h),
          GetBuilder<OnboardingController>(
            builder: (_) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  key: ValueKey<String>(
                    controller.titles[controller.carouselIndex],
                  ),
                  controller.titles[controller.carouselIndex],
                  textAlign: TextAlign.center,
                  style: context.headline1,
                ),
              );
            },
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: 280.w,
            child: GetBuilder<OnboardingController>(
              builder: (_) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    key: ValueKey<String>(
                      controller.subTitles[controller.carouselIndex],
                    ),
                    controller.subTitles[controller.carouselIndex],
                    textAlign: TextAlign.center,
                    style: context.body1,
                  ),
                );
              },
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
              text: AppStrings.next,
              onPressed: controller.onNextButtonPressed,
            ),
          ),
        ],
      ),
    );
  }
}
