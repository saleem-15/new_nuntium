import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/core/constants/get_builders_ids.dart';
import 'package:new_nuntium/routes/routes.dart';

class ProfileController extends GetxController {
  bool isNotificationsOn = true;

  String userName = 'Eren Turkmen';

  String userEmail = 'ertasfsdfadfsuken@gmail.com';

  ImageProvider<Object>? userImage = NetworkImage(
    'https://media.istockphoto.com/id/1309328823/photo/headshot-portrait-of-smiling-male-employee-in-office.jpg?s=612x612&w=0&k=20&c=kPvoBm6qCYzQXMAn9JUtqLREXe9-PlZyMl9i-ibaVuY=',
  );

  void toggleNotifications(bool value) {
    isNotificationsOn = value;
    update([AppGetBuildersIds.notificationsSwitch]);
  }

  void onLanguagePressed() {
    Get.toNamed(Routes.languageView);
  }

  void onChangePasswordPressed() {}

  void onPrivacyPressed() {}

  void onTermsAndConditionsPressed() {
    Get.toNamed(Routes.termsAndConditionsView);
  }

  void onSignOutPressed() {}
}
