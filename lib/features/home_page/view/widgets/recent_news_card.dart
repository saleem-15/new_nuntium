import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/widgets/app_gradient_overlay.dart';
import 'package:new_nuntium/features/home_page/controller/home_page._controller.dart';
import 'package:new_nuntium/features/home_page/data/news_model.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';

class RecentNewsCard extends StatelessWidget {
  final News news;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;

  const RecentNewsCard({
    super.key,
    required this.news,
    required this.onTap,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 256.h,
        width: 256.w,
        // إعادة المسافة
        margin: EdgeInsets.only(right: 16.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            // 2. إجبار العناصر على ملء الكونتينر
            fit: StackFit.expand,
            children: [
              // Image
              _buildImage(),

              // Black Gradient
              const Positioned.fill(child: AppGradientOverlay()),

              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Positioned.fill(
      child: CachedNetworkImage(
        imageUrl: news.imageUrl,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 500),
        placeholder: (_, _) => Container(
          color: AppColors.greyLighter,
          child: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
        errorWidget: (_, _, _) => Container(
          color: AppColors.greyLighter,
          child: const Icon(
            Icons.broken_image,
            color: AppColors.greyPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        //Bookmark Icon Padding
        right: 10.w,
        top: 10.w,

        //Category,Title Padding
        left: 20.w,
        bottom: 20.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Bookmark Button
          Align(
            alignment: Alignment.topRight,
            child: GetBuilder<HomeController>(
              assignId: true,
              id: news.id,
              builder: (context) {
                return GetBuilder<HomeController>(
                  assignId: true,
                  id: news.id,
                  builder: (controller) {
                    return IconButton(
                      onPressed: onBookmarkTap,
                      icon: SvgPicture.asset(
                        alignment: Alignment.topRight,
                        // تغيير الأيقونة بناءً على هل هي محفوظة أم لا
                        news.isSaved
                            ? AppIcons.bookmarkFilled
                            : AppIcons.bookmark,
                        colorFilter: const ColorFilter.mode(
                          AppColors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Spacer(),

          // Category
          Text(
            news.category.toUpperCase(),
            style: context.body2.copyWith(
              fontSize: 12.sp,
              color: AppColors.white.withValues(alpha: 0.8),
              fontWeight: AppFonts.regular,
            ),
          ),
          SizedBox(height: 8.h),

          // Title
          Text(
            news.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.body1.copyWith(
              color: AppColors.white,
              fontWeight: AppFonts.bold,
              fontSize: 16.sp,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
