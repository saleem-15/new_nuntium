import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/config/routes.dart';
import 'package:new_nuntium/core/services/shared_prefrences.dart';

class SplashController extends GetxController {
  final _appSharedPref = getIt<AppSharedPrefs>();

  @override
  void onInit() {
    super.onInit();
    _navigateToNextRoute();
  }

  Future<void> _navigateToNextRoute() async {
    await Future.delayed(const Duration(seconds: 2));

    // Checks if its the first time to open the app
    bool isFirstTime = _appSharedPref.isFirstTime;

    // Verify if the user is logged in
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (isFirstTime) {
      Get.offAllNamed(Routes.onBoardingView);
    } else if (currentUser != null) {
      // If the user is logged in
      Get.offAllNamed(Routes.mainView);
    } else {
      Get.offAllNamed(Routes.signUpView);
    }

    _appSharedPref.setIsFirstTimeToFalse();
  }
}
