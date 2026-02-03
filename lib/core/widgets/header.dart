import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';

/// The header of  page in the app
/// It has a default padding
/// ```dart
///padding: EdgeInsets.only(top: 72.h, bottom: 32.h),
/// ```
class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.title,
    required this.subTtitle,
    this.topPadding,
    this.bottomPadding,
    this.horizentalPadding,
  });

  final String title;
  final String subTtitle;
  final double? topPadding;
  final double? bottomPadding;
  final double? horizentalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 28.h,
        bottom: 32.h,
        right: horizentalPadding ?? 0,
        left: horizentalPadding ?? 0,
      ),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              title,
              style: context.headline1,
              textAlign: TextAlign.start,
            ),
          ),

          SizedBox(height: 8.h),

          Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(subTtitle, style: context.body1),
          ),
        ],
      ),
    );
  }
}
