import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:new_nuntium/features/Auth/controller/create_new_password_controller.dart';
import 'package:new_nuntium/features/Auth/controller/forget_password_controller.dart';
import 'package:new_nuntium/features/Auth/controller/login_controller.dart';
import 'package:new_nuntium/features/Auth/controller/sign_up_controller.dart';
import 'package:new_nuntium/features/Auth/controller/verification_code_controller.dart';
import 'package:new_nuntium/features/onboarding/controller/onboarding_controller.dart';
import 'package:new_nuntium/features/onboarding/controller/welcome_controller.dart';
import 'package:new_nuntium/features/splash/controller/splash_controller.dart';

void initSplash() {
  Get.put(SplashController());
}

void disposeSplash() {
  Get.delete<SplashController>();
}

void initOnboarding() {
  disposeSplash();
  Get.put(OnboardingController());
}

void disposeOnboarding() {
  Get.delete<OnboardingController>();
}

void initWelcome() {
  disposeOnboarding();
  Get.put(WelcomeController());
}

void disposeWelcome() {
  Get.delete<WelcomeController>();
}

void initLogin() {
  disposeWelcome();
  Get.put(LoginController());
}

void disposeLogin() {
  Get.delete<LoginController>();
}

void initSignUp() {
  disposeLogin();
  Get.put(SignUpController());
}

void disposeSignUp() {
  Get.delete<SignUpController>();
}

void initVerificationCode() {
  disposeSignUp();
  Get.put(VerificationCodeController());
}

void disposeVerificationCode() {
  Get.delete<VerificationCodeController>();
}

void initCreateNewPassword() {
  disposeVerificationCode();
  Get.put(CreateNewPasswordController());
}

void disposeCreateNewPassword() {
  Get.delete<CreateNewPasswordController>();
}

void initForgetPassword() {
  Get.put(ForgetPasswordController());
}

void disposeForgetPassword() {
  disposeLogin();
  Get.delete<ForgetPasswordController>();
}
