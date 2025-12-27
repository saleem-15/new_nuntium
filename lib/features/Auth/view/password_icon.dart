import 'package:flutter/material.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';

class PasswordIcon extends StatelessWidget {
  const PasswordIcon({
    super.key,
    required this.isPasswordHidden,
    required this.onPressed,
    required this.isPasswordEmpty,
  });

  final bool isPasswordEmpty;
  final bool isPasswordHidden;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      // Show the icon only if the text field has text
      child: isPasswordEmpty
          ? null
          : IconButton(
              // مفتاح ضروري للأنيميشن
              key: const ValueKey('password_icon'),
              icon: Icon(
                isPasswordHidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.greyPrimary,
              ),
              onPressed: onPressed,
            ),
    );
  }
}
