import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/config/routes.dart';

class OnboardingController extends GetxController {
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();

  int carouselIndex = 0;

  final List<String> titles = [
    AppStrings.onboardingTitle1,
    AppStrings.onboardingTitle2,
    AppStrings.onboardingTitle3,
  ];

  final List<String> subTitles = [
    AppStrings.onboardingSubtitle1,
    AppStrings.onboardingSubtitle2,
    AppStrings.onboardingSubtitle3,
  ];

  void onSliderChanged(int index, _) {
    carouselIndex = index;
    update();
  }

  void onNextButtonPressed() {
    if (carouselIndex < titles.length - 1) {
      carouselSliderController.nextPage();
    } else {
      Get.offNamed(Routes.welcomeView);
    }
  }
}
