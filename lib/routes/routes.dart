import 'package:flutter/material.dart';

import '../config/dependency_injection.dart';
import '../features/splash/view/splash_screen.dart';

class Routes {
  static const String splashView = '/splash_view';
  static const String onBoardingView = '/on_boarding_view';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      //************************** Welcoming Views **************************
      case Routes.splashView:
        initSplash();
        return MaterialPageRoute(builder: (_) => const SplashView());

      default:
        return unDefinedRoute(settings.name);
    }
  }

  static Route<dynamic> unDefinedRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text('Page Not Found')),
        body: Center(child: Text('$routeName Does Not Exist')),
      ),
    );
  }
}
