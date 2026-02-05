import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // لتشغيل أيقونات SVG
import 'package:get/get.dart';
import 'package:new_nuntium/core/resources/app_assets.dart'; // تأكد من وجود مسارات الأيقونات
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/features/article_details/presentation/controller/article_controller.dart';

class ArticleView extends GetView<ArticleController> {
  const ArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // نجعل الخلفية سوداء لتناسب الصورة
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. صورة الخلفية (تغطي الجزء العلوي)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 400.h, // ارتفاع الصورة
            child: CachedNetworkImage(
              imageUrl: controller.article.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[300]),
              errorWidget: (context, url, error) =>
                  Container(color: Colors.grey),
            ),
          ),

          // طبقة شفافة خفيفة فوق الصورة لتحسين رؤية الأزرار العلوية
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

          // 2. الأزرار العلوية (Back, Bookmark, Share)
          Positioned(
            top: 50.h, // لنتجاوز الـ StatusBar
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton(
                  iconPath: AppIcons.back, // استبدل بمسار أيقونة الرجوع لديك
                  matchTextDirection: true,

                  onTap: controller.onBackPressed,
                ),

                Row(
                  children: [
                    GetBuilder<ArticleController>(
                      assignId: true,
                      id: controller.article.id,
                      builder: (_) => _buildIconButton(
                        iconPath: controller.article.isSaved
                            ? AppIcons.bookmarkFilled
                            : AppIcons.bookmark,
                        onTap: controller.onBookmarkPressed,
                        color: controller.article.isSaved
                            ? AppColors.greyPrimary
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

          // 3. محتوى المقال (الورقة البيضاء المنزلقة)
          Positioned.fill(
            top: 320.h, // يبدأ النزول من هنا ليغطي جزءاً من الصورة
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // التصنيف (Category Badge)
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

                    // العنوان (Title)
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

                    // المحتوى النصي (Content)
                    Text(
                      controller.article.content +
                          controller.article.content +
                          controller.article.content,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[800],
                        height: 1.6,
                      ),
                    ),

                    SizedBox(height: 40.h), // مسافة في الأسفل
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget مساعد لإنشاء الأزرار العلوية الشفافة
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
        decoration: BoxDecoration(
          color: Colors.grey.withValues(
            alpha: 0.3,
          ), // خلفية زجاجية (Glassmorphism)
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
