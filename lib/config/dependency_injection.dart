import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:new_nuntium/features/onboarding/controller/onboarding_controller.dart';
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
