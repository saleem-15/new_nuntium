import 'package:flutter/material.dart';
import 'package:new_nuntium/features/Auth/view/create_new_password_view.dart';
import 'package:new_nuntium/features/Auth/view/forget_password_view.dart';
import 'package:new_nuntium/features/Auth/view/login_view.dart';
import 'package:new_nuntium/features/Auth/view/sign_up_view.dart';
import 'package:new_nuntium/features/Auth/view/verification_code_view.dart';
import 'package:new_nuntium/features/bookmarks/bookmarks_view.dart';
import 'package:new_nuntium/features/home/view/home_page.dart';
import 'package:new_nuntium/features/main/main_view.dart';
import 'package:new_nuntium/features/onboarding/view/onboarding_screen.dart';
import 'package:new_nuntium/features/onboarding/view/welcome_screen.dart';
import 'package:new_nuntium/features/profile/view/profile_view.dart';
import 'package:new_nuntium/features/select_favorite_topics/view/select_favorite_topics_view.dart';

import '../config/dependency_injection.dart';
import '../features/splash/view/splash_screen.dart';

class Routes {
  Routes._();

  static const String splashView = '/splash_view';
  static const String onBoardingView = '/on_boarding_view';
  static const String welcomeView = '/welcome_view';
  static const String loginView = '/login_view';
  static const String signUpView = '/sign_up_view';
  static const String forgetPasswordView = '/forget_password_view';
  static const String createNewPasswordView =
      '/create_new_password_view';
  static const String verificationCodeView =
      '/verification_code_view';
  static const String selectFavoriteTopicsView =
      '/select_favorite_topics_view';

  static const String mainView = '/main_view';
  static const String homeView = '/home_page_view';
  static const String bookmarksView = '/bookmarks_view';
  static const String profileView = '/profile_view';
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

      case Routes.forgetPasswordView:
        initForgetPassword();
        return MaterialPageRoute(
          builder: (_) => const ForgetPasswordView(),
        );

      case Routes.verificationCodeView:
        initVerificationCode();
        return MaterialPageRoute(
          builder: (_) => const VerificationCodeView(),
        );

      case Routes.createNewPasswordView:
        initCreateNewPassword();
        return MaterialPageRoute(
          builder: (_) => const CreateNewPasswordView(),
        );
      case Routes.signUpView:
        initSignUp();
        return MaterialPageRoute(builder: (_) => const SignUpView());

      case Routes.selectFavoriteTopicsView:
        initSelectFavoriteTopics();
        return MaterialPageRoute(
          builder: (_) => const SelectFavoriteTopics(),
        );

      case Routes.mainView:
        initMain();
        return MaterialPageRoute(builder: (_) => const MainView());

      case Routes.homeView:
        initHome();
        return MaterialPageRoute(builder: (_) => const HomeView());

      case Routes.bookmarksView:
        initBookmarks();
        return MaterialPageRoute(
          builder: (_) => const BookmarksView(),
        );

      case Routes.profileView:
        initProfile();
        return MaterialPageRoute(builder: (_) => const ProfileView());

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
