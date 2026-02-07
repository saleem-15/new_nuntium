import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';

void showSignoutDialog({required void Function()? onSignOutPressed}) {
  Get.generalDialog(
    barrierDismissible: true,
    barrierLabel: '',
    pageBuilder: (context, anim1, anim2) {
      return Container();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.scale(
        scale: anim1.value,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: Colors.white,
          title: Icon(
            Icons.warning_amber_rounded,
            size: 50.sp,
            color: AppColors.purplePrimary,
          ),
          content: Text(
            AppStrings.logoutConfirmation,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.blackPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.only(
            bottom: 24.h,
            right: 16.w,
            left: 16.w,
          ),
          actions: [
            // زر الإلغاء
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                AppStrings.cancel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            // زر التأكيد (نستخدم تصميم مشابه لزر التطبيق الأساسي لكن مصغر)
            SizedBox(
              width: 100.w,
              height: 40.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purplePrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: onSignOutPressed, // استدعاء دالة الخروج الفعلية
                child: Text(
                  AppStrings.yes,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
