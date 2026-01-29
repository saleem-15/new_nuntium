import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';

class CustomRichText extends StatelessWidget {
  final String firstText;
  final String secondText;
  final VoidCallback onTap;

  const CustomRichText({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: firstText,
            style: context.body1.copyWith(
              fontWeight: AppFonts.medium,
              color: AppColors.blackLighter,
            ),
          ),

          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              // Ensures the entire padding is clickable
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              // Increases surface area
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.sp,
                  vertical: 10.sp,
                ),
                child: Text(
                  ' $secondText',
                  style: context.body1.copyWith(
                    fontWeight: AppFonts.bold,
                    color: AppColors.blackPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
