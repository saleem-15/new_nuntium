import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/config/routes.dart';
import 'package:new_nuntium/core/constants/constanst.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/features/auth/presentation/controller/resend_time_controller.dart';

void showSuccessDialog(
  String email, {
  required Function(String email) reSendEmail,
  required ResendTimerController timerController,
}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. الأيقونة
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: AppColors.purplePrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mark_email_read_rounded,
                size: 50.sp,
                color: AppColors.purplePrimary,
              ),
            ),
            SizedBox(height: 20.h),

            // 2. العنوان
            Text(
              AppStrings.checkYourMail,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),

            Text(
              "${AppStrings.emailSentDescription}\n$email",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),

            // 3. زر العودة لتسجيل الدخول
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purplePrimary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  // حذف الكنترولر عند الإغلاق لتوفير الذاكرة
                  Get.delete<ResendTimerController>(
                    tag: Constants.resendDialogControllerId,
                  );
                  Get.offAllNamed(Routes.loginView);
                },
                child: Text(
                  AppStrings.doneBackToLogin,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // 4. زر إعادة الإرسال مع المؤقت (Obx)
            Obx(() {
              final isRunning = timerController.isTimerRunning.value;
              final seconds = timerController.remainingSeconds.value;

              return TextButton(
                // تعطيل الزر إذا كان المؤقت يعمل
                onPressed: isRunning
                    ? null
                    : () {
                        timerController.resend(reSendEmail, email);
                      },
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12.sp), // تأكد من نوع الخط
                    children: [
                      TextSpan(
                        text: isRunning
                            ? "${AppStrings.resendLink} " // "إعادة الإرسال خلال"
                            : AppStrings.resendLink, // "لم يصلك؟ إعادة الإرسال"
                        style: TextStyle(
                          color: isRunning
                              ? Colors.grey
                              : AppColors.greyPrimary,
                        ),
                      ),
                      // إظهار العداد فقط إذا كان يعمل
                      if (isRunning)
                        TextSpan(
                          text: "($seconds s)",
                          style: TextStyle(
                            color: AppColors.purplePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  ).then((_) {
    // التأكد من حذف الكنترولر في حال تم إغلاق الديالوج بطريقة أخرى
    if (Get.isRegistered<ResendTimerController>(tag: 'resend_dialog')) {
      Get.delete<ResendTimerController>(tag: 'resend_dialog');
    }
  });
}
