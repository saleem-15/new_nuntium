import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:new_nuntium/config/routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    _navigateToOnboarding();
    super.onInit();
  }

  Future<void> _navigateToOnboarding() async {
    await Future.delayed(Duration(seconds: 3));

    Get.toNamed(Routes.onBoardingView);
  }
}
