import 'package:carousel_slider/carousel_options.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  int carouselIndex = 0;

  void animateSliderIndicator(
    int pageIndex,
    CarouselPageChangedReason _,
  ) {
    carouselIndex = pageIndex;

    update();
  }
}
