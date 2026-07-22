import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuntium/config/dependency_injection.dart';
import 'package:nuntium/config/routes.dart';
import 'package:nuntium/core/errors/crash_reporter.dart';
import 'package:nuntium/core/resources/app_assets.dart';
import 'package:nuntium/core/localization/language_config.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';

Future<void> main() async {
  await initApp();
  EquatableConfig.stringify = true;

  // Limit app usage to Portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // تمرير جميع أخطاء فلاتر (الأخطاء البرمجية) إلى Crashlytics
  FlutterError.onError = (errorDetails) {
    getIt<CrashReporter>().reportError(
      exception: errorDetails.exception,
      stackTrace: errorDetails.stack,
      reason: CrashlyticsErrors.unexpectedError,
      fatal: true,
    );
  };

  // تمرير الأخطاء التي تحدث خارج إطار فلاتر (مثل الأخطاء غير المتزامنة)
  PlatformDispatcher.instance.onError = (error, stack) {
    getIt<CrashReporter>().reportError(
      exception: error,
      stackTrace: stack,
      reason: CrashlyticsErrors.unexpectedError,
      fatal: true,
    );
    return true;
  };

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
      supportedLocales: LanguageConfig.supportedLocales,
      path: kTranslationPath,
      fallbackLocale: LanguageConfig.fallBackLocale,
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
      child: MaterialApp(
        title: 'Nuntium',
        // Translation settings
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        //
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Routes.splashView,
        builder: (context, child) {
          return Directionality(
            textDirection: LanguageConfig.getTextDirection(context),
            child: child!,
          );
        },
      ),
    );
  }
}
