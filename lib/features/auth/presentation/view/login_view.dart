import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:new_nuntium/core/constants/app_assets.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/utils/app_validator.dart';
import 'package:new_nuntium/core/widgets/custom_rich_text.dart';
import 'package:new_nuntium/core/widgets/custom_text_field.dart';
import 'package:new_nuntium/core/widgets/header.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:new_nuntium/features/auth/presentation/controller/login_controller.dart';
import 'package:new_nuntium/features/auth/presentation/view/widgets/password_icon.dart';
import 'package:new_nuntium/features/auth/presentation/view/widgets/social_button.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Header(
                title: AppStrings.loginTitle,
                subTtitle: AppStrings.loginSubTitle,
              ),

              //Email Field
              CustomTextField(
                controller: controller.emailController,
                hintText: AppStrings.emailAdress,
              prefixIcon: AppIcons.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: AppValidator.validateEmail,
              ),

              SizedBox(height: 16.h),

              //Password Field
              GetBuilder<LoginController>(
                builder: (_) => CustomTextField(
                  controller: controller.passwordController,
                  hintText: AppStrings.password,
                  prefixIcon: AppIcons.lock,
                  isPassword: controller.isPasswordHidden,
                  suffixIcon: PasswordIcon(
                    isPasswordEmpty: controller.isPasswordEmpty,
                    isPasswordHidden: controller.isPasswordHidden,
                    onPressed: controller.togglePasswordVisibility,
                  ),
                  validator: AppValidator.validatePassword,
                ),
              ),

              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: controller.onForgetPasswordPressed,
                  child: Text(
                    AppStrings.forgotPassword,
                    style: context.body1.copyWith(fontWeight: AppFonts.medium),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              Obx(
                () => PrimaryButton(
                  text: AppStrings.signIn,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.onSignInPressed,
                ),
              ),

              SizedBox(height: 48.h),

              Text(
                AppStrings.or,
                style: context.body1.copyWith(fontWeight: AppFonts.semiBold),
              ),

              SizedBox(height: 48.h),

              SocialButton(
                text: AppStrings.signInwithGoogle,
                icon: AppAssets.google,
                onPressed: controller.onSignInWithGooglePressed,
              ),

              SizedBox(height: 16.h),

              SocialButton(
                text: AppStrings.signInwithFacebook,
                icon: AppAssets.facebook,
                onPressed: controller.onSignInWithFacebookPressed,
              ),

              SizedBox(height: 50.h),

              CustomRichText(
                firstText: AppStrings.dontHaveAccount,
                secondText: AppStrings.signUp,
                onTap: controller.onSignUpPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
