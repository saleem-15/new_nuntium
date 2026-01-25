import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';

import 'app_back_button.dart';

class NuntiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subTitle; // Optional subtitle
  final bool showBackButton;
  final bool centerTitle;

  const NuntiumAppBar({
    super.key,
    required this.title,
    this.subTitle,
    this.showBackButton = true,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBackButton ? const AppBackButton() : null,
      centerTitle: centerTitle,

      // We use a Column inside the title to stack the texts
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: centerTitle
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(title, style: context.headline1, textAlign: TextAlign.start),

          // Show subtitle only if it's provided
          if (subTitle != null) ...[
            SizedBox(height: 8.h),
            Text(subTitle!, style: context.body1),
          ],
        ],
      ),
    );
  }

  // Increase height if subtitle exists to maintain the "premium" look
  @override
  Size get preferredSize => Size.fromHeight(subTitle == null ? 55.h : 136.h);
}
