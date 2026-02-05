import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/constants/get_builders_ids.dart';
import 'package:new_nuntium/core/resources/app_assets.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/core/utils/app_validator.dart';
import 'package:new_nuntium/core/widgets/app_back_button.dart';
import 'package:new_nuntium/core/widgets/custom_text_field.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:new_nuntium/features/auth/presentation/controller/change_password_controller.dart';

import 'widgets/password_icon.dart';

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
              // // Current Password
              // Obx(
              //   () => _buildPasswordField(
              //     label: AppStrings.currentPassword,
              //     controller: controller.currentPasswordController,
              //     isObscure: controller.isCurrentHidden.value,
              //     onToggle: controller.toggleCurrentVisibility,
              //     textInputAction: TextInputAction.next,
              //     validator: (val) => (val == null || val.isEmpty)
              //         ? AppStrings.requiredField
              //         : null,
              //   ),
              // ),

              // SizedBox(height: 16.h),

              // //Password Field
              // Obx(
              //   () => CustomTextField(
              //     controller: controller.currentPasswordController,
              //     hintText: AppStrings.password,
              //     prefixIcon: AppIcons.lock,
              //     isPassword: controller.isCurrentHidden.value,
              //     suffixIcon: PasswordIcon(
              //       isPasswordEmpty: controller.isPasswordEmpty,
              //       isPasswordHidden: controller.isPasswordHidden,
              //       onPressed: controller.togglePasswordVisibility,
              //     ),
              //     validator: AppValidator.validatePassword,
              //   ),
              // ),
              // // New Password
              // Obx(
              //   () => _buildPasswordField(
              //     label: AppStrings.newPassword,
              //     controller: controller.newPasswordController,
              //     isObscure: controller.isNewHidden.value,
              //     onToggle: controller.toggleNewVisibility,
              //     textInputAction: TextInputAction.next,

              //     validator: (val) {
              //       if (val == null || val.length < 6) {
              //         return AppStrings.tooShort;
              //       }
              //       return null;
              //     },
              //   ),
              // ),

              // SizedBox(height: 16.h),

              // // Repeat New Password
              // Obx(
              //   () => _buildPasswordField(
              //     label: AppStrings.repeateNewPassword,
              //     controller: controller.repeatPasswordController,
              //     isObscure: controller.isRepeatHidden.value,
              //     onToggle: controller.toggleRepeatVisibility,
              //     textInputAction: TextInputAction.done,

              //     validator: (val) {
              //       if (val != controller.newPasswordController.text) {
              //         return AppStrings.passwordsDontMatch;
              //       }
              //       return null;
              //     },
              //   ),
              // ),

              // 1. Current Password Field
              // Obx(
              //   () => CustomTextField(
              //     controller: controller.currentPasswordController,
              //     hintText: AppStrings.currentPassword,
              //     prefixIcon: AppIcons.lock,
              //     isPassword: controller.isCurrentHidden.value,
              //     keyboardType: TextInputType.visiblePassword,
              //     textInputAction: TextInputAction.next,
              //     suffixIcon: PasswordIcon(
              //       isPasswordEmpty: controller.isCurrentPasswordEmpty.value,
              //       isPasswordHidden: controller.isCurrentHidden.value,
              //       onPressed: controller.toggleCurrentVisibility,
              //     ),
              //     validator: AppValidator.validatePassword,
              //   ),
              // ),

              // SizedBox(height: 16.h),

              // // 2. New Password Field
              // Obx(
              //   () => CustomTextField(
              //     controller: controller.newPasswordController,
              //     hintText: AppStrings.newPassword,
              //     prefixIcon: AppIcons.lock,
              //     isPassword: controller.isNewHidden.value,
              //     keyboardType: TextInputType.visiblePassword,
              //     textInputAction: TextInputAction.next,
              //     suffixIcon: PasswordIcon(
              //       isPasswordEmpty: controller.isNewPasswordEmpty.value,
              //       isPasswordHidden: controller.isNewHidden.value,
              //       onPressed: controller.toggleNewVisibility,
              //     ),
              //     validator: AppValidator.validatePassword,
              //   ),
              // ),

              // SizedBox(height: 16.h),

              // // 3. Repeat New Password Field (بدون أيقونة إظهار)
              // Obx(
              //   () => CustomTextField(
              //     controller: controller.repeatPasswordController,
              //     hintText: AppStrings.repeateNewPassword,
              //     prefixIcon: AppIcons.lock,
              //     // نجعلها مخفية دائماً أو مربوطة بالمتغير الافتراضي
              //     isPassword: controller.isRepeatHidden.value,
              //     // لا نمرر suffixIcon هنا ليظهر الحقل بدون أيقونة العين
              // validator: (value) => AppValidator.validateMatchPassword(
              //   value,
              //   controller.newPasswordController.text.trim(),
              // ),
              // keyboardType: TextInputType.visiblePassword,
              // textInputAction: TextInputAction.done,
              //   ),
              // ),

              // 1. Current Password Field
              GetBuilder<ChangePasswordController>(
                id: AppGetBuildersIds.changePasswordCurrentVisibility,
                builder: (controller) {
                  return CustomTextField(
                    controller: controller.currentPasswordController,
                    focusNode: controller.currentPasswordFocus,
                    hintText: AppStrings.currentPassword,
                    prefixIcon: AppIcons.lock,
                    isPassword: controller.isCurrentHidden,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(
                        context,
                      ).requestFocus(controller.newPasswordFocus);
                    },
                    suffixIcon: PasswordIcon(
                      isPasswordEmpty: controller.isCurrentPasswordEmpty,
                      isPasswordHidden: controller.isCurrentHidden,
                      onPressed: controller.toggleCurrentVisibility,
                    ),
                    validator: AppValidator.validatePassword,
                  );
                },
              ),

              SizedBox(height: 16.h),

              // 2. New Password Field
              GetBuilder<ChangePasswordController>(
                id: AppGetBuildersIds.changePasswordNewVisibility,
                builder: (controller) {
                  return CustomTextField(
                    controller: controller.newPasswordController,
                    focusNode: controller.newPasswordFocus,
                    hintText: AppStrings.newPassword,
                    prefixIcon: AppIcons.lock,
                    isPassword: controller.isNewHidden,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(
                        context,
                      ).requestFocus(controller.repeatPasswordFocus);
                    },
                    suffixIcon: PasswordIcon(
                      isPasswordEmpty: controller.isNewPasswordEmpty,
                      isPasswordHidden: controller.isNewHidden,
                      onPressed: controller.toggleNewVisibility,
                    ),
                    validator: AppValidator.validatePassword,
                  );
                },
              ),

              SizedBox(height: 16.h),

              // 3. Repeat New Password Field
              CustomTextField(
                controller: controller.repeatPasswordController,
                focusNode: controller.repeatPasswordFocus,
                hintText: AppStrings.repeateNewPassword,
                prefixIcon: AppIcons.lock,
                isPassword: true,
                validator: (value) => AppValidator.validateMatchPassword(
                  value,
                  controller.newPasswordController.text.trim(),
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 16.h),

              // PrimaryButton(
              //   text: AppStrings.changePassword,
              //   onPressed: controller.updatePassword,
              // ),
              GetBuilder<ChangePasswordController>(
                id: AppGetBuildersIds.changePasswordButton,
                builder: (controller) {
                  return PrimaryButton(
                    text: AppStrings.changePassword,
                    isLoading: controller.isLoading,
                    onPressed: controller.updatePassword,
                  );
                },
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
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      validator: validator,
      textInputAction: textInputAction,
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
