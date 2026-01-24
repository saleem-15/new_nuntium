import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/config/dependency_injection.dart';
import 'package:new_nuntium/core/constants/app_assets.dart';
import 'package:new_nuntium/core/services/language_service.dart';
import 'package:new_nuntium/config/routes.dart';

import 'core/theme/app_theme.dart';

Future<void> main() async {
  await initApp();

  // ضبط إعدادات النظام لتشمل المساحة العلوية والسفلية
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // شفافية الأعلى
      systemNavigationBarColor: Colors.transparent, // شفافية الأسفل
      systemNavigationBarIconBrightness:
          Brightness.dark, // أيقونات الأسفل (سوداء)
      statusBarIconBrightness: Brightness.dark, // أيقونات الأعلى (سوداء)
    ),
  );

  // تفعيل وضع الحافة إلى الحافة (Edge-to-Edge)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await ScreenUtil.ensureScreenSize();

  runApp(
    EasyLocalization(
      supportedLocales: Get.find<LanguageService>().supportedLocales,
      path: kTranslationPath,
      fallbackLocale: Get.find<LanguageService>().fallBackLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: GetMaterialApp(
        title: 'Nuntium',
        // Translation settings
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        //
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Routes.mainView,
        builder: (context, child) {
          return Directionality(
            textDirection: LanguageService.getTextDirection(context),
            child: child!,
          );
        },
      ),
    );
  }
}
