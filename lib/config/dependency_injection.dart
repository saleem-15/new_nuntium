import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_nuntium/core/constants/constanst.dart';
import 'package:new_nuntium/core/extensions/get_it_extension.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/core/network/api_client.dart';
import 'package:new_nuntium/core/network/network_info.dart';
import 'package:new_nuntium/core/services/language_service.dart';
import 'package:new_nuntium/core/services/shared_prefrences.dart';
import 'package:new_nuntium/core/services/storage_service.dart';
import 'package:new_nuntium/features/article_details/presentation/controller/presentation/controller/article_controller.dart';
import 'package:new_nuntium/features/article_details/presentation/controller/presentation/controller/article_webview_controller.dart';
import 'package:new_nuntium/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:new_nuntium/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:new_nuntium/features/auth/domain/repositories/auth_repository.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/login_use_case.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/reset_password.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/sign_in_with_facebook_use_case.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/signup_use_case.dart';
import 'package:new_nuntium/features/auth/presentation/controller/change_password_controller.dart';
import 'package:new_nuntium/features/auth/presentation/controller/create_new_password_controller.dart';
import 'package:new_nuntium/features/auth/presentation/controller/forget_password_controller.dart';
import 'package:new_nuntium/features/auth/presentation/controller/login_controller.dart';
import 'package:new_nuntium/features/auth/presentation/controller/resend_time_controller.dart';
import 'package:new_nuntium/features/auth/presentation/controller/sign_up_controller.dart';
import 'package:new_nuntium/features/auth/presentation/controller/verification_code_controller.dart';
import 'package:new_nuntium/features/bookmarks/data/repository/bookmark_repository_imp.dart';
import 'package:new_nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/check_if_saved_use_case.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/delete_bookmark_use_case.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/get_saved_articles_use_case.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/save_bookmark_use_case.dart';
import 'package:new_nuntium/features/bookmarks/domain/use_cases/watch_bookmarks_changes_use_case.dart';
import 'package:new_nuntium/features/bookmarks/presentation/controller/bookmarks_controller.dart';
import 'package:new_nuntium/features/categories/domain/repository/cateogries_repository.dart';
import 'package:new_nuntium/features/categories/domain/use_case/get_cateogories_use_case.dart';
import 'package:new_nuntium/features/categories/presentation/controller/categories_controller.dart';
import 'package:new_nuntium/features/home/data/data_source/news_remote_data_source.dart';
import 'package:new_nuntium/features/home/data/repository/news_repository_impl.dart';
import 'package:new_nuntium/features/home/domain/repository/news_repository.dart';
import 'package:new_nuntium/features/home/domain/use_cases/fetch_news_use_case.dart';
import 'package:new_nuntium/features/home/domain/use_cases/toggle_bookmark_use_case.dart';
import 'package:new_nuntium/features/home/presentation/controller/home_controller.dart';
import 'package:new_nuntium/features/language/presentation/controller/language_controller.dart';
import 'package:new_nuntium/features/main/controller/main_controller.dart';
import 'package:new_nuntium/features/onboarding/controller/onboarding_controller.dart';
import 'package:new_nuntium/features/onboarding/controller/welcome_controller.dart';
import 'package:new_nuntium/features/profile/data/repository/profile_repository_impl.dart';
import 'package:new_nuntium/features/profile/domain/repository/profile_repository.dart';
import 'package:new_nuntium/features/profile/domain/use_cases/get_user_data_use_case.dart';
import 'package:new_nuntium/features/profile/view/controller/profile_controller.dart';
import 'package:new_nuntium/features/select_favorite_topics/controller/select_favorite_topics_controller.dart';
import 'package:new_nuntium/features/splash/controller/splash_controller.dart';
import 'package:new_nuntium/features/terms_and_conditions/presentation/controller/terms_and_conditions_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/domain/use_cases/change_password_use_case.dart';
import '../features/categories/data/repository/categories_repository_impl.dart';
import '../features/home/domain/use_cases/search_news_use_case.dart';

final getIt = GetIt.instance;

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.registerSingletonAsync(
    () async => AppSharedPrefs(await SharedPreferences.getInstance()),
  );

  await Firebase.initializeApp();

  // Load '.env' file which holds the Api Key
  await dotenv.load(fileName: ".env");
  await EasyLocalization.ensureInitialized();

  Get.put(LanguageService(), permanent: true);

  // local storage dependecy
  final storageService = StorageService();
  await storageService.init();
  getIt.registerSingleton<StorageService>(storageService);

  initAuth();
  getIt.registerSingleton(ApiClient());

  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(InternetConnectionChecker()),
  );
}

void initSplash() {
  Get.put(SplashController());
}

void disposeSplash() {
  Get.delete<SplashController>();
}

void initOnboarding() {
  disposeSplash();
  Get.put(OnboardingController());
}

void disposeOnboarding() {
  Get.delete<OnboardingController>();
}

void initWelcome() {
  disposeOnboarding();
  Get.put(WelcomeController());
}

void disposeWelcome() {
  Get.delete<WelcomeController>();
}

void initAuth() {
  getIt.safeRegisterLazySingleton(() => FirebaseAuth.instance);

  getIt.safeRegisterLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );

  getIt.safeRegisterLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(getIt<AuthRemoteDataSource>(), getIt<NetworkInfo>()),
  );
}

void initLogin() {
  disposeWelcome();
  getIt.safeRegisterLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));

  getIt.safeRegisterLazySingleton(
    () => SignInWithGoogleUseCase(getIt<AuthRepository>()),
  );

  getIt.safeRegisterLazySingleton(
    () => SignInWithFacebookUseCase(getIt<AuthRepository>()),
  );

  Get.put(LoginController());
}

void disposeLogin() {
  Get.delete<LoginController>();
}

void initSignUp() {
  disposeLogin();
  getIt.safeRegisterLazySingleton(() => SignupUseCase(getIt<AuthRepository>()));
  Get.put(SignUpController());
}

void disposeSignUp() {
  Get.delete<SignUpController>();
}

void initSelectFavoriteTopics() {
  disposeLogin();
  disposeSignUp();
  Get.put(SelectFavoriteTopicsController());
}

void disposeSelectFavoriteTopics() {
  Get.delete<SelectFavoriteTopicsController>();
}

void initVerificationCode() {
  disposeSignUp();
  Get.put(VerificationCodeController());
}

void disposeVerificationCode() {
  Get.delete<VerificationCodeController>();
}

void initCreateNewPassword() {
  disposeVerificationCode();
  Get.put(CreateNewPasswordController());
}

void disposeCreateNewPassword() {
  Get.delete<CreateNewPasswordController>();
}

void initForgetPassword() {
  getIt.safeRegisterLazySingleton(
    () => ResetPasswordUseCase(getIt<AuthRepository>()),
  );

  Get.lazyPut(
    () => ResendTimerController(),
    tag: Constants.resendDialogControllerId,
  );

  Get.put(ForgetPasswordController());
}

void disposeForgetPassword() {
  disposeLogin();
  Get.delete<ForgetPasswordController>();
}

void initMain() {
  disposeSelectFavoriteTopics();
  initBookmarks();
  initHome();
  initCategories();
  initProfile();
  Get.put(MainController());
}

void disposeMainPage() {
  disposeHomePage();
  disposeCategoriesPage();

  Get.delete<MainController>();
}

void initHome() {
  // 1. Data Layer
  getIt.safeRegisterLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(),
  );

  getIt.safeRegisterLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSource(getIt<ApiClient>()),
  );

  getIt.safeRegisterLazySingleton<NewsRepository>(
    () =>
        NewsRepositoryImpl(getIt<NewsRemoteDataSource>(), getIt<NetworkInfo>()),
  );

  // 2. Domain Layer
  getIt.safeRegisterLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(getIt<CategoriesRepository>()),
  );

  getIt.safeRegisterLazySingleton<FetchNewsUseCase>(
    () => FetchNewsUseCase(getIt<NewsRepository>()),
  );

  getIt.safeRegisterLazySingleton<ToggleBookmarkUseCase>(
    () => ToggleBookmarkUseCase(getIt<BookmarkRepository>()),
  );

  getIt.safeRegisterLazySingleton<SearchNewsUseCase>(
    () => SearchNewsUseCase(getIt<NewsRepository>()),
  );

  Get.put(HomeController());
}

void disposeHomePage() {
  Get.delete<HomeController>();
}

void initCategories() {
  Get.put(CategoriesController());
}

void disposeCategoriesPage() {
  Get.delete<CategoriesController>();
}

void initBookmarks() {
  getIt.safeRegisterLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(getIt<StorageService>()),
  );

  getIt.safeRegisterLazySingleton<SaveBookmarkUseCase>(
    () => SaveBookmarkUseCase(getIt<BookmarkRepository>()),
  );
  getIt.safeRegisterLazySingleton<DeleteBookmarkUseCase>(
    () => DeleteBookmarkUseCase(getIt<BookmarkRepository>()),
  );
  getIt.safeRegisterLazySingleton<CheckIfSavedUseCase>(
    () => CheckIfSavedUseCase(getIt<BookmarkRepository>()),
  );

  getIt.safeRegisterLazySingleton<GetSavedArticlesUseCase>(
    () => GetSavedArticlesUseCase(getIt<BookmarkRepository>()),
  );

  getIt.safeRegisterLazySingleton(
    () => WatchBookmarksChangesUseCase(getIt<BookmarkRepository>()),
  );

  Get.put(BookmarksController());
}

void disposeBookmarksPage() {
  Get.delete<BookmarksController>();
}

void initProfile() {
  getIt.safeRegisterLazySingleton(
    () => SignOutUseCase(getIt<AuthRepository>()),
  );

  getIt.safeRegisterLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(FirebaseAuth.instance),
  );

  getIt.safeRegisterLazySingleton(
    () => GetUserDataUseCase(getIt<ProfileRepository>()),
  );

  Get.put(ProfileController());
}

void disposeProfilePage() {
  Get.delete<ProfileController>();
}

void initLanguage() {
  Get.put(LanguageController());
}

void disposeLanguagePage() {
  Get.delete<LanguageController>();
}

void initChangePassword() {
  getIt.safeRegisterLazySingleton(
    () => ChangePasswordUseCase(getIt<AuthRepository>()),
  );

  Get.put(ChangePasswordController());
}

void disposeChangePasswordPage() {
  Get.delete<ChangePasswordController>();
}

void initTermsAndConditions() {
  Get.put(TermsAndConditionsController());
}

void disposeTermsAndConditionsPage() {
  Get.delete<TermsAndConditionsController>();
}

// عدل الدالة لتستقبل Article
void initArticle(Article article) {
  // نحذف الكنترلر القديم (إن وجد) لضمان عدم بقاء بيانات مقال سابق
  if (Get.isRegistered<ArticleController>()) {
    Get.delete<ArticleController>();
  }

  // نحقن الكنترلر ونعطيه المقال مباشرة عبر الـ Constructor
  Get.put(ArticleController(article: article));
}

void disposeArticlePage() {
  Get.delete<ArticleController>();
}

void initOriginalArticle(String articleUrl) {
  // نحذف الكنترلر القديم (إن وجد) لضمان عدم بقاء بيانات مقال سابق
  if (Get.isRegistered<OriginalArticleWebViewController>()) {
    Get.delete<OriginalArticleWebViewController>();
  }

  // نحقن الكنترلر ونعطيه المقال مباشرة عبر الـ Constructor
  Get.put(OriginalArticleWebViewController(articleUrl));
}

void disposeOriginalArticlePage() {
  Get.delete<OriginalArticleWebViewController>();
}
