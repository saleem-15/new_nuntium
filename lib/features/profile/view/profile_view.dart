import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:new_nuntium/core/constants/get_builders_ids.dart';
import 'package:new_nuntium/core/extensions/theme_extension.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';
import 'package:new_nuntium/features/profile/profile_controller.dart';
import 'package:new_nuntium/features/profile/view/widgets/settings_list_tile.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 72.h),
        child: Column(
          children: [
            _profileHeader(context),

            SizedBox(height: 32.h),

            ListView(
              shrinkWrap: true,
              children: [
                SettingsListTile(
                  title: AppStrings.notifications,
                  trailing: Transform.scale(
                    scale: 0.8,
                    child: GetBuilder<ProfileController>(
                      assignId: true,
                      id: AppGetBuildersIds.notificationsSwitch,
                      builder: (_) {
                        return Switch(
                          activeTrackColor: AppColors.purplePrimary,
                          value: controller.isNotificationsOn,
                          onChanged: controller.toggleNotifications,
                        );
                      },
                    ),
                  ),
                ),
                SettingsListTile(
                  title: AppStrings.language,
                  onPressed: controller.onLanguagePressed,
                ),
                SettingsListTile(
                  title: AppStrings.changePassword,
                  onPressed: controller.onChangePasswordPressed,
                ),
                SettingsListTile(
                  title: AppStrings.privacy,
                  onPressed: controller.onPrivacyPressed,
                ),
                SettingsListTile(
                  title: AppStrings.termsAndConditions,
                  onPressed: controller.onTermsAndConditionsPressed,
                ),
                SettingsListTile(
                  title: AppStrings.signOut,
                  trailing: Icon(
                    Icons.logout,
                    color: AppColors.greyDarker,
                    size: 24.sp,
                  ),
                  onPressed: controller.onSignOutPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader(BuildContext context) {
    return SizedBox(
      height: 136.h,
      // width: 250.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppStrings.profile, style: context.headline1),

          Row(
            children: [
              CircleAvatar(
                radius: 36.r,
                foregroundImage: controller.userImage,
              ),
              SizedBox(width: 24.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.userName,
                    style: context.body2.copyWith(
                      color: AppColors.blackPrimary,
                    ),
                  ),
                  Text(
                    controller.userEmail,
                    style: context.body1.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.greyPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
