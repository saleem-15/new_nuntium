import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_nuntium/core/resources/manager_fonts.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: ManagerColors.purplePrimary,
        minimumSize: Size(double.infinity, 56.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: ManagerFontFamily.fontFamily,
          color: ManagerColors.white,
          fontWeight: ManagerFontWeight.semiBold,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
