import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/widgets/custom_rich_text.dart';
import 'package:new_nuntium/core/widgets/custom_text_field.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:new_nuntium/features/Auth/controller/sign_up_controller.dart';
import 'package:new_nuntium/features/Auth/view/password_icon.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),

        child: Form(
          key: controller.signUpFormKey,
          child: Column(
            children: [
              SizedBox(height: 72.h),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.signUpTitle,
                  style: context.headline1,
                  textAlign: TextAlign.left,
                ),
              ),

              SizedBox(height: 8.h),

              Text(AppStrings.signUpSubTitle, style: context.body1),

              SizedBox(height: 32.h),

              //User Name Field
              CustomTextField(
                controller: controller.userNameController,
                hintText: AppStrings.userName,
                prefixIcon: Icons.person,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 16.h),

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
              GetBuilder<SignUpController>(
                builder: (_) => CustomTextField(
                  controller: controller.passwordController,
                  hintText: AppStrings.password,
                  prefixIcon: Icons.lock_outline,
                  isPassword: controller.isPasswordHidden,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).nextFocus(),
                  textInputAction: TextInputAction.next,
                  suffixIcon: PasswordIcon(
                    isPasswordEmpty: controller.isPasswordEmpty,
                    isPasswordHidden: controller.isPasswordHidden,
                    onPressed: controller.togglePasswordVisibility,
                  ),
                  validator: controller.validatePassword,
                ),
              ),

              SizedBox(height: 16.h),

              //Repeat Password Field
              GetBuilder<SignUpController>(
                builder: (_) => CustomTextField(
                  controller: controller.repeatPasswordController,
                  hintText: AppStrings.repeatPassword,
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: controller.validatePassword,
                ),
              ),

              SizedBox(height: 24.h),

              PrimaryButton(
                text: AppStrings.signIn,
                onPressed: controller.onSignUpPressed,
              ),

              SizedBox(height: 180.h),

              CustomRichText(
                firstText: AppStrings.haveAnAccount,
                secondText: AppStrings.signIn,
                onTap: controller.onSignInPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
