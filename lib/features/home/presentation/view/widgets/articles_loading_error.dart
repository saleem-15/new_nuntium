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
          // عرض صورة الخطأ من ملف الأصول الخاص بك
          Image.asset(AppAssets.error, width: 216.w),
          SizedBox(height: 20.h),
          // عرض نص الخطأ باستخدام الخطوط والألوان المعرفة في الثيم
          Text(
            // يفضل إضافة هذا المفتاح في AppStrings لاحقاً
            "Error Loading News",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: AppFonts.bold, // استخدام الوزن من AppFonts
              fontFamily: AppFonts.fontFamily,
              color: AppColors.blackPrimary, // استخدام اللون من AppColors
            ),
          ),
          SizedBox(height: 20.h),
          // زر إعادة المحاولة باستخدام مكون الزر الموحد PrimaryButton
          SizedBox(
            width: 160.w, // تحديد عرض مناسب للزر
            child: PrimaryButton(
              onPressed: onRefreshPressed,
              text: AppStrings.tryAgain, // استخدام النص الموجود في AppStrings
            ),
          ),
        ],
      ),
    );
  }
}
