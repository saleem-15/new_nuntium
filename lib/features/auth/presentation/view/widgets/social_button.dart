import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.greyLighter),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: AppColors.greyLighter,
              width: 1.sp,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.zero,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 15.w,
                child: Image.asset(icon, width: 24.w, height: 24.h),
              ),
              Text(
                text,
                style: context.body1.copyWith(
                  fontWeight: AppFonts.semiBold,
                  color: AppColors.greyDarker,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
