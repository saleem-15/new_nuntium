import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_nuntium/routes/routes.dart';

import 'core/theme/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
