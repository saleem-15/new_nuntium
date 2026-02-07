import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/resources/app_assets.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:new_nuntium/features/article_details/presentation/controller/article_controller.dart';

class ArticleView extends GetView<ArticleController> {
  const ArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 400.h,
            child: CachedNetworkImage(
              imageUrl: controller.article.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[300]),
              errorWidget: (context, url, error) =>
                  Container(color: Colors.grey),
            ),
          ),

          // Black gradient, To enhance the vision of upper buttons
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120.h,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Upper buttons
          Positioned(
            top: 50.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton(
                  iconPath: AppIcons.back,
                  matchTextDirection: true,
                  onTap: controller.onBackPressed,
                ),
                Row(
                  children: [
                    GetBuilder<ArticleController>(
                      id: controller.article.id,
                      builder: (_) => _buildIconButton(
                        iconPath: controller.article.isSaved
                            ? AppIcons.bookmarkFilled
                            : AppIcons.bookmark,
                        onTap: controller.onBookmarkPressed,
                        color: controller.article.isSaved
                            ? AppColors
                                  .purplePrimary // لون التفعيل
                            : null,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    _buildIconButton(
                      iconPath: AppIcons.share,
                      onTap: controller.onSharePressed,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Article Content (Scrollable)
          Positioned.fill(
            top: 320.h,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: SingleChildScrollView(
                // ✅ إضافة مساحة سفلية كبيرة لضمان عدم اختفاء النص خلف الزر العائم
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 24.h,
                  bottom: 100.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.purplePrimary,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        controller.article.sourceName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Title
                    Text(
                      controller.article.title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Content
                    Text(
                      controller.article.content,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[800],
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // View original article Button (Sticky Footer)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // Add upper shadow, To seperate the button from the article content
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false, 
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: PrimaryButton(
                    text: AppStrings.viewOriginalArticle,
                    onPressed: controller.onViewOriginalArticlePressed,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required String iconPath,
    required VoidCallback onTap,
    bool matchTextDirection = false,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        width: 40.w,

        // Glassmorphism
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.all(8.w),
        child: SvgPicture.asset(
          iconPath,
          matchTextDirection: matchTextDirection,
          colorFilter: ColorFilter.mode(color ?? Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
