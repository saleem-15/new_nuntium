import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';

class ArticlesLoadingIndicator extends StatelessWidget {
  const ArticlesLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      // استخدام درجات الرمادي القياسية للـ Shimmer لضمان ظهور التأثير بوضوح
      baseColor: Colors.grey[300]!, 
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            width: double.infinity, // لملء العرض المتاح بناءً على الـ Margin
            height: 272.h,
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
            ).copyWith(bottom: 24.h),
            decoration: BoxDecoration(
              color: AppColors.white, // اللون هنا dummy لكي يعمل الـ Shimmer عليه
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }
}