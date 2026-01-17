import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_nuntium/core/extensions/theme_extension.dart';

class AppBarWithBackButton extends StatelessWidget {
  const AppBarWithBackButton({
    super.key,
    required this.onPressed,
    required this.title,
  });
  final void Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: -5.h,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.arrow_back_rounded),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(title, style: context.headline1),
        ),
      ],
    );
  }
}
