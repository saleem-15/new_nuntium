import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/constants/app_assets.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/features/home/presentation/controller/home_controller.dart';

class HomeSearchBar extends GetView<HomeController> {
  final Function(String)? onChanged;
  final void Function() onSearchPressed;
  final TextEditingController searchFieldController;

  const HomeSearchBar({
    super.key,
    this.onChanged,
    required this.onSearchPressed,
    required this.searchFieldController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 56.h,
          decoration: BoxDecoration(
            color: AppColors.greyLighter,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              // تحديث اللون بناءً على الحالة في الكنترولر
              color: controller.isSearchFieldFocused.value
                  ? AppColors.purplePrimary
                  : Colors.transparent,
              width: 1.5.sp,
            ),
          ),
          child: TextField(
            onEditingComplete: controller.search,
            focusNode: controller.searchFocusNode,
            controller: searchFieldController,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: AppStrings.search,
              hintStyle: context.body1.copyWith(color: AppColors.greyPrimary),
              prefixIcon: IconButton(
                padding: EdgeInsets.all(14.w),

                onPressed: onSearchPressed,
                icon: SvgPicture.asset(
                  AppIcons.search,
                  colorFilter: ColorFilter.mode(
                    controller.isSearchFieldFocused.value
                        ? AppColors.purplePrimary
                        : AppColors.greyPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.all(14.w),
                child: SvgPicture.asset(AppIcons.microphone),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ),
      ),
    );
  }
}
