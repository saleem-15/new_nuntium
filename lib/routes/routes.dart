import 'package:flutter/material.dart';
import 'package:new_nuntium/features/Auth/view/login_view.dart';
import 'package:new_nuntium/features/onboarding/view/onboarding_screen.dart';
import 'package:new_nuntium/features/onboarding/view/welcome_screen.dart';

import '../config/dependency_injection.dart';
import '../features/splash/view/splash_screen.dart';

class Routes {
  Routes._();

  static const String splashView = '/splash_view';
  static const String onBoardingView = '/on_boarding_view';
  static const String welcomeView = '/welcome_view';
  static const String loginView = '/login_view';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      //************************** Welcoming Views **************************
      case Routes.splashView:
        initSplash();
        return MaterialPageRoute(builder: (_) => const SplashView());

      case Routes.onBoardingView:
        initOnboarding();
        return MaterialPageRoute(
          builder: (_) => const OnboardingView(),
        );

      case Routes.welcomeView:
        initWelcome();
        return MaterialPageRoute(builder: (_) => const WelcomeView());

      case Routes.loginView:
        initLogin();
        return MaterialPageRoute(builder: (_) => const LoginView());

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
