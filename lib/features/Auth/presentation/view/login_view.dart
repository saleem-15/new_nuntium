import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:new_nuntium/core/constants/app_assets.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_fonts.dart';
import 'package:new_nuntium/core/widgets/custom_rich_text.dart';
import 'package:new_nuntium/core/widgets/custom_text_field.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:new_nuntium/features/Auth/presentation/controller/login_controller.dart';
import 'package:new_nuntium/features/Auth/presentation/view/widgets/password_icon.dart';
import 'package:new_nuntium/features/Auth/presentation/view/widgets/social_button.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: controller.loginFormKey,
          child: Column(
            children: [
              SizedBox(height: 72.h),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.loginTitle,
                  style: context.headline1,
                  textAlign: TextAlign.left,
                ),
              ),

              SizedBox(height: 8.h),

              Text(AppStrings.loginSubTitle, style: context.body1),

              SizedBox(height: 32.h),

              //Email Field
              CustomTextField(
                controller: controller.emailController,
                hintText: AppStrings.emailAdress,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 16.h),

              //Password Field
              GetBuilder<LoginController>(
                builder: (_) => CustomTextField(
                  controller: controller.passwordController,
                  hintText: AppStrings.password,
                  prefixIcon: Icons.lock_outline,
                  isPassword: controller.isPasswordHidden,
                  suffixIcon: PasswordIcon(
                    isPasswordEmpty: controller.isPasswordEmpty,
                    isPasswordHidden: controller.isPasswordHidden,
                    onPressed: controller.togglePasswordVisibility,
                  ),
                  validator: controller.validatePassword,
                ),
              ),

              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: controller.onForgetPasswordPressed,
                  child: Text(
                    AppStrings.forgotPassword,
                    style: context.body1.copyWith(
                      fontWeight: AppFonts.medium,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              PrimaryButton(
                text: AppStrings.signIn,
                onPressed: controller.onSignInPressed,
              ),

              SizedBox(height: 48.h),

              Text(
                AppStrings.or,
                style: context.body1.copyWith(
                  fontWeight: AppFonts.semiBold,
                ),
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
