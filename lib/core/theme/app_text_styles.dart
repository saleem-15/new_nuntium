import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Big Headline
  static TextStyle headLine1 = TextStyle(
    fontSize: 24.sp,
    fontWeight: AppFonts.semiBold,
    fontFamily: AppFonts.fontFamily,
    color: AppColors.blackPrimary,
  );

  // Body Text
  static TextStyle bodyText1 = TextStyle(
    fontSize: 16.sp,
    fontWeight: AppFonts.regular,
    fontFamily: AppFonts.fontFamily,
    color: AppColors.greyPrimary,
  );

  static TextStyle bodyText2 = TextStyle(
    fontSize: 16.sp,
    fontWeight: AppFonts.regular,
    fontFamily: AppFonts.fontFamily,
    color: AppColors.blackPrimary,
  );

  //Button Text
  static TextStyle buttonText = TextStyle(
    fontSize: 16.sp,
    fontWeight: AppFonts.semiBold,
    fontFamily: AppFonts.fontFamily,
    color: Colors.white,
  );
}
