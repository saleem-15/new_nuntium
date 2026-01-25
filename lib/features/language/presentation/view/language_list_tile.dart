import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_nuntium/core/constants/app_assets.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/features/language/model/language.dart';

class LanguageListTile extends StatelessWidget {
  const LanguageListTile({
    super.key,
    required this.language,
    required this.isCurrentLocale,
    required this.onPressed,
  });

  final Language language;
  final bool isCurrentLocale;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 56.h,

      margin: EdgeInsets.only(bottom: 16.h),
      decoration: ShapeDecoration(
        color: isCurrentLocale
            ? AppColors.purplePrimary
            : AppColors.greyLighter,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: 24.w, end: 21.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///title
              Text(
                language.name,
                style: context.body1.copyWith(
                  fontWeight: AppFonts.semiBold,
                  color: isCurrentLocale
                      ? AppColors.white
                      : AppColors.greyDarker,
                ),
              ),
              Visibility(
                visible: isCurrentLocale,
                child: SvgPicture.asset(AppIcons.check),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
