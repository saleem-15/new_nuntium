import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:new_nuntium/core/resources/app_assets.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/utils/app_validator.dart';
import 'package:new_nuntium/core/widgets/custom_rich_text.dart';
import 'package:new_nuntium/core/widgets/custom_text_field.dart';
import 'package:new_nuntium/core/widgets/header.dart';
import 'package:new_nuntium/core/widgets/primary_button.dart';
import 'package:new_nuntium/core/widgets/scaffold_with_header.dart';
import 'package:new_nuntium/features/auth/presentation/controller/sign_up_controller.dart';
import 'package:new_nuntium/features/auth/presentation/view/widgets/password_icon.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithHeader(
      header: Header(
        title: AppStrings.signUpTitle,
        subTtitle: AppStrings.signUpSubTitle,
      ),
      body: Form(
        key: controller.formKey,
        child: Column(
          children: [
            SizedBox(height: 32.h),

            //User Name Field
            CustomTextField(
              controller: controller.userNameController,
              hintText: AppStrings.userName,
              prefixIcon: AppIcons.user,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validator: AppValidator.validateName,
            ),

            SizedBox(height: 16.h),

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
            GetBuilder<SignUpController>(
              builder: (_) => CustomTextField(
                controller: controller.passwordController,
                hintText: AppStrings.password,
                prefixIcon: AppIcons.lock,
                isPassword: controller.isPasswordHidden,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                suffixIcon: PasswordIcon(
                  isPasswordEmpty: controller.isPasswordEmpty,
                  isPasswordHidden: controller.isPasswordHidden,
                  onPressed: controller.togglePasswordVisibility,
                ),
                validator: AppValidator.validatePassword,
              ),
            ),

            SizedBox(height: 16.h),

            //Repeat Password Field
            GetBuilder<SignUpController>(
              builder: (_) => CustomTextField(
                controller: controller.repeatPasswordController,
                hintText: AppStrings.repeatPassword,
                prefixIcon: AppIcons.lock,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: (value) => AppValidator.validateMatchPassword(
                  value,
                  controller.passwordController.text.trim(),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            Obx(
              () => PrimaryButton(
                text: AppStrings.signUp,
                isLoading: controller.isLoading.value,
                onPressed: controller.onSignUpPressed,
              ),
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
    );
  }
}
