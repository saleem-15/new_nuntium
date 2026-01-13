import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';

class LanguageListTile extends StatelessWidget {
  const LanguageListTile({
    super.key,
    required this.languageName,
    this.onPressed,
  });

  final String languageName;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 56.h,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: ShapeDecoration(
        color: AppColors.greyLighter,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: 24.w, end: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///title
              Text(
                languageName,
                style: context.body1.copyWith(
                  color: AppColors.greyDarker,
                  fontWeight: AppFonts.semiBold,
                ),
              ),

              Icon(
                Icons.check,
                color: AppColors.greyDarker,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
