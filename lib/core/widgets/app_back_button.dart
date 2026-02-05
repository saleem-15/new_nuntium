import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/resources/app_assets.dart';

/// A reusable back button widget that supports RTL mirroring and custom actions.
class AppBackButton extends StatelessWidget {
  /// Optional callback for custom back logic. If null, defaults to [Get.back()].
  final VoidCallback? onPressed;

  const AppBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Get.back(),
      child: Container(
        // Transparent background increases the touchable area for better UX
        color: Colors.transparent,
        padding: EdgeInsetsDirectional.only(
          end: 12.w,
          top: 12.w,
          bottom: 12.w,
          start: 12.w,
        ),
        child: SvgPicture.asset(
          AppIcons.back,

          // Automatically mirrors the icon for RTL (Arabic) layouts
          matchTextDirection: true,
        ),
      ),
    );
  }
}
