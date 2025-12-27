import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/routes/routes.dart';

import 'core/theme/app_theme.dart';

Future<void> main() async {
  await ScreenUtil.ensureScreenSize();

  runApp(const MyApp());
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
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Routes.splashView,
      ),
    );
  }
}
