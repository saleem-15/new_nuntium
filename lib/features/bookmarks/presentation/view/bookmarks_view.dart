import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:new_nuntium/core/constants/app_assets.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/widgets/header.dart';
import 'package:new_nuntium/features/bookmarks/presentation/controller/bookmarks_controller.dart';
import 'package:new_nuntium/features/home/presentation/view/widgets/recommended_news_card.dart';

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

            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.articles.isEmpty) {
                log("Bookmarks is empty");
                return Expanded(child: _buildEmbty(context));
              }
              log("Bookmarks");

              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.articles.length,
                  itemBuilder: (_, index) {
                    final article = controller.articles[index];
                    return Dismissible(
                      // Unique key is required for Dismissible
                      key: ValueKey(article.id),

                      // Allow swiping from Start to End (Right side in LTR, Left in RTL)
                      // You can change to 'horizontal' to allow both sides
                      direction: DismissDirection.startToEnd,

                      // The UI shown behind the item when swiping
                      background: Container(
                        margin: EdgeInsets.only(
                          bottom: 16.h,
                        ), // Match card margin
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        alignment: Alignment
                            .centerLeft, // Align icon to the swipe side
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppIcons.delete,
                              colorFilter: ColorFilter.mode(
                                AppColors.white,
                                BlendMode.srcIn,
                              ),
                              width: 24.sp,
                            ),

                            SizedBox(width: 8.w),
                            Text(
                              AppStrings.delete,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Actual Logic when swipe is completed
                      onDismissed: (direction) {
                        controller.removeBookmark(article);
                      },

                      // The Article Card
                      child: RecommendedArticleCard(
                        article: article,
                        margin: EdgeInsets.only(bottom: 16.h),
                        onTap: controller.onBookmarkTapped,
                      ),
                    );
                  },
                ),
              );
            }),
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
          width: 300.w,
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
