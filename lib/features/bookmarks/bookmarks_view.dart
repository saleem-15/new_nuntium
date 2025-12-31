import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:new_nuntium/core/constants/app_assets.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/widgets/header.dart';
import 'package:new_nuntium/features/bookmarks/bookmarks_controller.dart';
import 'package:new_nuntium/features/home/data/news_model.dart';
import 'package:new_nuntium/features/home/view/widgets/recommended_news_card.dart';

class BookmarksView extends GetView<BookmarksController> {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Header(
              title: AppStrings.bookmarksPageTitle,
              subTtitle: AppStrings.bookmarksPageSubTitle,
            ),

            Expanded(
              child: controller.bookmarks.isEmpty
                  ? _buildEmbty(context)
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.bookmarks.length,
                      itemBuilder: (_, index) => RecommendedNewsCard(
                        news: controller.bookmarks[index],
                        margin: EdgeInsets.only(bottom: 16.h),
                        onTap: controller.onArticleTapped,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmbty(BuildContext context) {
    return Column(
      children: [
        Spacer(flex: 1),
        Container(
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffEEF0FB),
          ),
          child: Center(
            child: SvgPicture.asset(
              AppIcons.book, // Using the bookmark icon
              width: 24.w,
              height: 24.w,
              colorFilter: const ColorFilter.mode(
                AppColors.purplePrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        SizedBox(
          width: 256.w,
          child: Text(
            AppStrings.noSavedArticles,
            textAlign: TextAlign.center,
            style: context.body2.copyWith(
              color: AppColors.blackPrimary,
              fontWeight: AppFonts.medium,
            ),
          ),
        ),
        Spacer(flex: 2),
      ],
    );
  }
}
