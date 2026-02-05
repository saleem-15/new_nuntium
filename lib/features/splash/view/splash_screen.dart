import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_nuntium/core/resources/app_assets.dart';
import 'package:new_nuntium/core/theme/app_colors.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.purplePrimary,
        body: Center(child: SvgPicture.asset(AppAssets.logo)),
      ),
    );
  }
}
