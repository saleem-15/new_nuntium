import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:new_nuntium/core/models/article.dart';
import 'package:new_nuntium/core/network/api_client.dart';
import 'package:new_nuntium/core/services/language_service.dart';
import 'package:new_nuntium/core/services/shared_prefrences.dart';
import 'package:new_nuntium/core/services/storage_service.dart';
import 'package:new_nuntium/features/article_details/presentation/controller/article_controller.dart';
import 'package:new_nuntium/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:new_nuntium/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:new_nuntium/features/auth/domain/repositories/auth_repository.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/login_use_case.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/sign_in_with_facebook_use_case.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:new_nuntium/features/auth/domain/use_cases/signup_use_case.dart';
import 'package:new_nuntium/features/auth/presentation/controller/change_password_controller.dart';
import 'package:new_nuntium/features/auth/presentation/controller/create_new_password_controller.dart';
import 'package:new_nuntium/features/auth/presentation/controller/forget_password_controller.dart';
import 'package:new_nuntium/features/auth/presentation/controller/login_controller.dart';
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
import 'package:new_nuntium/features/categories/controller/categories_controller.dart';
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
import 'package:new_nuntium/features/profile/controller/profile_controller.dart';
import 'package:new_nuntium/features/select_favorite_topics/controller/select_favorite_topics_controller.dart';
import 'package:new_nuntium/features/splash/controller/splash_controller.dart';
import 'package:new_nuntium/features/terms_and_conditions/presentation/controller/terms_and_conditions_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  getIt.registerLazySingleton(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );
}

void initLogin() {
  disposeWelcome();
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));

  getIt.registerLazySingleton(
    () => SignInWithGoogleUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton(
    () => SignInWithFacebookUseCase(getIt<AuthRepository>()),
  );

  Get.put(LoginController());
}

void disposeLogin() {
  Get.delete<LoginController>();
}

void initSignUp() {
  disposeLogin();
  getIt.registerLazySingleton(() => SignupUseCase(getIt<AuthRepository>()));
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
  getIt.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSource(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(getIt<NewsRemoteDataSource>()),
  );

  // 2. Domain Layer
  getIt.registerLazySingleton<FetchNewsUseCase>(
    () => FetchNewsUseCase(getIt<NewsRepository>()),
  );

  getIt.registerLazySingleton<ToggleBookmarkUseCase>(
    () => ToggleBookmarkUseCase(getIt<BookmarkRepository>()),
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
  getIt.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(getIt<StorageService>()),
  );

  getIt.registerLazySingleton<SaveBookmarkUseCase>(
    () => SaveBookmarkUseCase(getIt<BookmarkRepository>()),
  );
  getIt.registerLazySingleton<DeleteBookmarkUseCase>(
    () => DeleteBookmarkUseCase(getIt<BookmarkRepository>()),
  );
  getIt.registerLazySingleton<CheckIfSavedUseCase>(
    () => CheckIfSavedUseCase(getIt<BookmarkRepository>()),
  );

  getIt.registerLazySingleton<GetSavedArticlesUseCase>(
    () => GetSavedArticlesUseCase(getIt<BookmarkRepository>()),
  );

  getIt.registerLazySingleton(
    () => WatchBookmarksChangesUseCase(getIt<BookmarkRepository>()),
  );

  Get.put(BookmarksController());
}

void disposeBookmarksPage() {
  Get.delete<BookmarksController>();
}

void initProfile() {
  getIt.registerLazySingleton(() => SignOutUseCase(getIt<AuthRepository>()));

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
