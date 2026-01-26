import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_nuntium/core/constants/app_assets.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';

class PageLoadingError extends StatelessWidget {
  final VoidCallback onRefreshPressed;

  const PageLoadingError({super.key, required this.onRefreshPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.error, width: 216.w),
          SizedBox(height: 20.h),
          Text(
            AppStrings.errorLoadingNews,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: AppFonts.bold,
              fontFamily: AppFonts.fontFamily,
              color: AppColors.blackPrimary,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: 160.w,
            child: PrimaryButton(
              onPressed: onRefreshPressed,
              text: AppStrings.tryAgain,
            ),
          ),
        ],
      ),
    );
  }
}
