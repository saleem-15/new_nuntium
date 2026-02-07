import 'package:flutter/material.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';
import 'package:new_nuntium/features/article_details/presentation/controller/presentation/view/article_view.dart';
import 'package:new_nuntium/features/auth/presentation/view/change_password_view.dart';
import 'package:new_nuntium/features/auth/presentation/view/forget_password_view.dart';
import 'package:new_nuntium/features/auth/presentation/view/login_view.dart';
import 'package:new_nuntium/features/auth/presentation/view/sign_up_view.dart';
import 'package:new_nuntium/features/auth/presentation/view/verification_code_view.dart';
import 'package:new_nuntium/features/bookmarks/presentation/view/bookmarks_view.dart';
import 'package:new_nuntium/features/home/presentation/view/home_page.dart';
import 'package:new_nuntium/features/language/presentation/view/language_view.dart';
import 'package:new_nuntium/features/main/main_view.dart';
import 'package:new_nuntium/features/onboarding/view/onboarding_screen.dart';
import 'package:new_nuntium/features/onboarding/view/welcome_screen.dart';
import 'package:new_nuntium/features/profile/view/profile_view.dart';
import 'package:new_nuntium/features/select_favorite_topics/view/select_favorite_topics_view.dart';
import 'package:new_nuntium/features/terms_and_conditions/presentation/view/app_content_view.dart';

import '../features/article_details/presentation/controller/presentation/view/original_article_webview.dart';
import '../features/splash/view/splash_screen.dart';
import 'dependency_injection.dart';

class Routes {
  Routes._();

  //  --- Welcoming ---
  static const String splashView = '/splash_view';
  static const String onBoardingView = '/on_boarding_view';
  static const String welcomeView = '/welcome_view';
  static const String selectFavoriteTopicsView = '/select_favorite_topics_view';

  //  --- Auth ---
  static const String loginView = '/login_view';
  static const String signUpView = '/sign_up_view';
  static const String forgetPasswordView = '/forget_password_view';
  static const String createNewPasswordView = '/create_new_password_view';
  static const String verificationCodeView = '/verification_code_view';

  //  --- Main Views ---
  static const String mainView = '/main_view';
  static const String homeView = '/home_page_view';
  static const String profileView = '/profile_view';
  static const String bookmarksView = '/bookmarks_view';
  static const String articleView = '/article_view';
  static const String originalArticleView = '/original_article_view';

  // --- Profile related ---
  static const String languageView = '/language_view';
  static const String changePasswordView = '/change_password_view';
  static const String termsAndConditionsView = '/terms_and_conditions_view';
  static const String privacyAndPolicyView = '/privacy_and_policy_view';
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
        return MaterialPageRoute(builder: (_) => const OnboardingView());

      case Routes.welcomeView:
        initWelcome();
        return MaterialPageRoute(builder: (_) => const WelcomeView());

      case Routes.selectFavoriteTopicsView:
        initSelectFavoriteTopics();
        return MaterialPageRoute(builder: (_) => const SelectFavoriteTopics());

      //************************** Auth Views **************************
      case Routes.loginView:
        initLogin();
        return MaterialPageRoute(builder: (_) => const LoginView());

      case Routes.forgetPasswordView:
        initForgetPassword();
        return MaterialPageRoute(builder: (_) => const ForgetPasswordView());

      case Routes.verificationCodeView:
        initVerificationCode();
        return MaterialPageRoute(builder: (_) => const VerificationCodeView());

      // case Routes.createNewPasswordView:
      //   initCreateNewPassword();
      //   return MaterialPageRoute(builder: (_) => const CreateNewPasswordView());
      case Routes.signUpView:
        initSignUp();
        return MaterialPageRoute(builder: (_) => const SignUpView());

      //************************** Main Views **************************
      case Routes.mainView:
        initMain();
        return MaterialPageRoute(builder: (_) => const MainView());

      case Routes.homeView:
        initHome();
        return MaterialPageRoute(builder: (_) => const HomeView());

      case Routes.articleView:
        // 1. Pick the arguments that was sent via Get.toNamed
        if (settings.arguments is Article) {
          final article = settings.arguments as Article;

          // 2. Inject the arguments in dependency injection method
          initArticle(article);
        }
        return MaterialPageRoute(builder: (_) => const ArticleView());

      case Routes.originalArticleView:
        // 1. Pick the arguments that was sent via Get.toNamed
        if (settings.arguments is String) {
          final articleUrl = settings.arguments as String;

          // 2. Inject the arguments in dependency injection method
          initOriginalArticle(articleUrl);
        }
        return MaterialPageRoute(
          builder: (_) => const OriginalArticleWebView(),
        );

      case Routes.bookmarksView:
        initBookmarks();
        return MaterialPageRoute(builder: (_) => const BookmarksView());

      //************************** Profile Views **************************
      case Routes.profileView:
        initProfile();
        return MaterialPageRoute(builder: (_) => const ProfileView());

      case Routes.languageView:
        initLanguage();
        return MaterialPageRoute(builder: (_) => const LanguageView());

      case Routes.changePasswordView:
        initChangePassword();
        return MaterialPageRoute(builder: (_) => const ChangePasswordView());

      case Routes.privacyAndPolicyView:
        initContentController();
        return MaterialPageRoute(
          builder: (_) => AppContentView(
            title: AppStrings.privacyPolicyTitle,
            content: AppStrings.privacyPolicyContent,
          ),
        );

      case Routes.termsAndConditionsView:
        initContentController();
        return MaterialPageRoute(
          builder: (_) => AppContentView(
            title: AppStrings.termsAndConditions,
            content: AppStrings.termsAndConditionsBody,
          ),
        );

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
