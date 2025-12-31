import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/features/home_page/data/news_model.dart';

class RecommendedNewsCard extends StatelessWidget {
  const RecommendedNewsCard({
    super.key,
    required this.news,
    required this.onTap,
  });

  final News news;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          right: 20.w,
          left: 20.w,
          bottom: 16.h,
        ),
        height: 96.h,
        child: SizedBox(
          width: ScreenUtil.defaultSize.width,
          child: Row(
            children: [
              //image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  width: 96.w,
                  height: 96.w,
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
              ),

              SizedBox(width: 16.w),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.category,
                      style: context.body1.copyWith(
                        fontSize: 14.sp,
                        fontWeight: AppFonts.regular,
                        color: AppColors.greyPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.fade,

                      style: context.body1.copyWith(
                        color: AppColors.blackPrimary,
                        fontWeight: AppFonts.semiBold,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
