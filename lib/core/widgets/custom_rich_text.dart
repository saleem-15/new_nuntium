import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
          TextSpan(
            text: ' $secondText',
            style: context.body1.copyWith(
              fontWeight: AppFonts.bold,
              color: AppColors.blackPrimary,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
