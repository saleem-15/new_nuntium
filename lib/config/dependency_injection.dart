import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:new_nuntium/features/splash/controller/splash_controller.dart';

void initSplash() {
  Get.put(SplashController());
}

void disposeSplash() {
  Get.delete<SplashController>();
}
