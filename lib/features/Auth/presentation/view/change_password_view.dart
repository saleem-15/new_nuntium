import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/widgets/app_back_button.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:new_nuntium/features/Auth/presentation/controller/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text(AppStrings.changePassword),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              // Current Password
              Obx(
                () => _buildPasswordField(
                  label: AppStrings.currentPassword,
                  controller: controller.currentPasswordController,
                  isObscure: controller.isCurrentHidden.value,
                  onToggle: controller.toggleCurrentVisibility,
                  validator: (val) => (val == null || val.isEmpty)
                      ? AppStrings.requiredField
                      : null,
                ),
              ),

              SizedBox(height: 16.h),

              // New Password
              Obx(
                () => _buildPasswordField(
                  label: AppStrings.newPassword,
                  controller: controller.newPasswordController,
                  isObscure: controller.isNewHidden.value,
                  onToggle: controller.toggleNewVisibility,
                  validator: (val) {
                    if (val == null || val.length < 6) {
                      return AppStrings.tooShort;
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(height: 16.h),

              // Repeat New Password
              Obx(
                () => _buildPasswordField(
                  label: AppStrings.repeateNewPassword,
                  controller: controller.repeatPasswordController,
                  isObscure: controller.isRepeatHidden.value,
                  onToggle: controller.toggleRepeatVisibility,
                  validator: (val) {
                    if (val != controller.newPasswordController.text) {
                      return AppStrings.passwordsDontMatch;
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(height: 16.h),

              PrimaryButton(
                text: AppStrings.changePassword,
                onPressed: controller.updatePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget مساعد لتقليل التكرار
  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isObscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      validator: validator,
      style: TextStyle(fontSize: 16.sp, color: AppColors.blackPrimary),
      decoration: InputDecoration(
        hintText: label, // النص التوضيحي
        hintStyle: TextStyle(color: AppColors.greyPrimary, fontSize: 16.sp),
        filled: true,
        fillColor: const Color(0xFFF3F4F6), // رمادي فاتح جداً حسب تصميم Nuntium
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),

        // الأيقونة الأمامية (القفل)
        prefixIcon: Padding(
          padding: EdgeInsets.all(12.w),
          // ⚠️ تأكد أن اسم الأيقونة لديك هو iconLock (أو password)
          child: Icon(Icons.lock_outline, color: AppColors.greyPrimary),
        ),

        // الأيقونة الخلفية (العين)
        suffixIcon: IconButton(
          icon: Icon(
            isObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.greyPrimary,
          ),
          onPressed: onToggle,
        ),

        // الحدود (Borders)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: AppColors.purplePrimary,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
}
