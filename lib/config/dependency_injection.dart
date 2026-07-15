import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nuntium/core/errors/crash_reporter.dart';
import 'package:nuntium/core/network/api_client.dart';
import 'package:nuntium/core/network/network_info.dart';
import 'package:nuntium/core/services/shared_prefrences.dart';
import 'package:nuntium/core/services/storage_service.dart';

import 'package:nuntium/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:nuntium/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nuntium/features/auth/domain/repositories/auth_repository.dart';
import 'package:nuntium/features/auth/domain/use_cases/login_use_case.dart';
import 'package:nuntium/features/auth/domain/use_cases/reset_password.dart';
import 'package:nuntium/features/auth/domain/use_cases/sign_in_with_facebook_use_case.dart';
import 'package:nuntium/features/auth/domain/use_cases/sign_in_with_google_use_case.dart';
import 'package:nuntium/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:nuntium/features/auth/domain/use_cases/signup_use_case.dart';
import 'package:nuntium/features/auth/presentation/cubit/change_password_cubit.dart';
import 'package:nuntium/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:nuntium/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:nuntium/features/auth/presentation/cubit/email_verification_cubit.dart';
import 'package:nuntium/features/bookmarks/data/repository/bookmark_repository_imp.dart';
import 'package:nuntium/features/bookmarks/domain/repository/bookmark_repository.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/check_if_saved_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/delete_bookmark_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/get_saved_articles_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/save_bookmark_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/watch_bookmarks_changes_use_case.dart';
import 'package:nuntium/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:nuntium/features/categories/domain/repository/cateogries_repository.dart';
import 'package:nuntium/features/categories/domain/use_case/get_cateogories_use_case.dart';
import 'package:nuntium/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:nuntium/features/home/data/data_source/news_remote_data_source.dart';
import 'package:nuntium/features/home/data/repository/news_repository_impl.dart';
import 'package:nuntium/features/home/domain/repository/news_repository.dart';
import 'package:nuntium/features/home/domain/use_cases/fetch_news_use_case.dart';
import 'package:nuntium/features/bookmarks/domain/use_cases/toggle_bookmark_use_case.dart';
import 'package:nuntium/features/main/cubit/main_cubit.dart';
import 'package:nuntium/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:nuntium/features/profile/data/repository/profile_repository_impl.dart';
import 'package:nuntium/features/profile/domain/repository/profile_repository.dart';
import 'package:nuntium/features/profile/domain/use_cases/get_user_data_use_case.dart';
import 'package:nuntium/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:nuntium/features/select_favorite_topics/cubit/select_favorite_topics_cubit.dart';
import 'package:nuntium/features/splash/cubit/splash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/domain/use_cases/change_password_use_case.dart';
import '../features/auth/domain/use_cases/send_email_verification_use_case.dart';
import '../features/auth/domain/use_cases/check_email_verified_use_case.dart';
import '../features/categories/data/repository/categories_repository_impl.dart';
import '../features/home/domain/use_cases/search_news_use_case.dart';
import '../features/home/presentation/bloc/home_bloc.dart';
import 'package:nuntium/features/auth/presentation/cubit/login_cubit.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Scope name constant — avoids magic strings scattered across the codebase
// ─────────────────────────────────────────────────────────────────────────────
const _sessionScopeName = 'user_session';

final getIt = GetIt.instance;

// ─────────────────────────────────────────────────────────────────────────────
// APP-LEVEL INIT
// Called once in main(). Registers deps that live for the entire app lifetime:
//   - Infrastructure: SharedPrefs, Firebase, ApiClient, NetworkInfo
//   - Auth wrappers: FirebaseAuth, AuthRemoteDataSource, AuthRepository
//     (these are STATELESS adapters — they hold no user-specific data)
//
// WHY NOT session-level?
//   AuthRepository just wraps FirebaseAuth calls. It carries no mutable state,
//   so it's safe to reuse across sessions. Rebuilding it every login is waste.
// ─────────────────────────────────────────────────────────────────────────────
Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.registerSingletonAsync(
    () async => AppSharedPrefs(await SharedPreferences.getInstance()),
  );

  await Firebase.initializeApp();

  // Send Crashlytics reports only in release/production mode
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
    kReleaseMode,
  );
  getIt.registerLazySingleton<CrashReporter>(() => FirebaseCrashReporter());

  await EasyLocalization.ensureInitialized();

  // local storage dependency
  final storageService = StorageService();
  await storageService.init();
  getIt.registerSingleton<StorageService>(storageService);

  // Infrastructure
  getIt.registerSingleton(ApiClient());
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(InternetConnectionChecker()),
  );

  // Auth layer — stateless wrappers, safe to keep at app level
  _initAuth();
}

/// Registers the auth infrastructure once at app startup.
/// These are pure adapters (no mutable user state), so they stay alive
/// across multiple login/logout cycles without leaking data.
void _initAuth() {
  getIt.registerLazySingleton(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(getIt<AuthRemoteDataSource>(), getIt<NetworkInfo>()),
  );

  // Auth use cases — stateless, depend only on AuthRepository.
  // Registered once here so every screen in the auth flow (login, sign-up,
  // forget-password) can resolve them without worrying about re-registration.
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => SignInWithGoogleUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => SignInWithFacebookUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(() => SignupUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => ResetPasswordUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => ChangePasswordUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(() => SignOutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => SendEmailVerificationUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => CheckEmailVerifiedUseCase(getIt<AuthRepository>()),
  );

  // EmailVerificationCubit — factory because a new instance is needed each time
  // the verification screen is opened (avoids stale timer state from a prior session).
  getIt.registerFactory<EmailVerificationCubit>(
    () => EmailVerificationCubit(
      sendEmailVerificationUseCase: getIt<SendEmailVerificationUseCase>(),
      checkEmailVerifiedUseCase: getIt<CheckEmailVerifiedUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
    ),
  );

  getIt.registerFactory<SelectFavoriteTopicsCubit>(
    () => SelectFavoriteTopicsCubit(),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SESSION-LEVEL INIT / RESET
//
// A "session" is one user's active login period (login → logout).
// Everything that could hold user-specific state lives here.
//
// HOW GETIT SCOPES WORK:
//   GetIt has a built-in scope stack. pushNewScope() adds a layer on top.
//   Everything registered after pushNewScope() belongs to that layer.
//   popScope() removes that layer and DISPOSES all its registrations.
//   The app-level deps below are untouched — they're on the bottom layer.
//
//   Stack after initSession():
//   ┌─────────────────────────────┐  ← session scope (repositories, BLoCs)
//   │   user_session scope        │
//   ├─────────────────────────────┤
//   │   app-level scope (default) │  ← Firebase, ApiClient, AuthRepository...
//   └─────────────────────────────┘
//
//   After resetSession():
//   ┌─────────────────────────────┐
//   │   app-level scope (default) │  ← same as before login, untouched
//   └─────────────────────────────┘
// ─────────────────────────────────────────────────────────────────────────────

/// Call this when navigating to the main view (after login).
/// Pushes a new named scope and registers all user-session dependencies.
void initSession() {
  // Guard: if a session scope already exists (e.g. deep-link edge case),
  // do nothing. A scope should only be pushed once.
  if (getIt.hasScope(_sessionScopeName)) return;

  getIt.pushNewScope(scopeName: _sessionScopeName);

  _initBookmarksDeps();
  _initHomeDeps();
  _initProfileDeps();
  _initCategoriesDeps();

  // Register MainCubit inside the user_session scope
  getIt.registerLazySingleton<MainCubit>(() => MainCubit());
}

/// Call this BEFORE navigating away from the main view on logout.
/// Pops the session scope — all registered deps are unregistered and disposed.
/// GetX controllers are explicitly deleted too.
Future<void> resetSession() async {
  // Pop the GetIt scope — this disposes ALL session-scoped singletons
  // (repositories, use cases, etc.) in one atomic operation.
  if (getIt.hasScope(_sessionScopeName)) {
    await getIt.popScope();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private session-scope helpers
// These are called only from initSession(). They are private (_prefix) to
// prevent accidental calls from outside, which would break scope ownership.
// ─────────────────────────────────────────────────────────────────────────────

void _initBookmarksDeps() {
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
  getIt.registerLazySingleton<WatchBookmarksChangesUseCase>(
    () => WatchBookmarksChangesUseCase(getIt<BookmarkRepository>()),
  );
  getIt.registerLazySingleton<BookmarksCubit>(
    () => BookmarksCubit(
      getSavedArticlesUseCase: getIt<GetSavedArticlesUseCase>(),
      deleteBookmarkUseCase: getIt<DeleteBookmarkUseCase>(),
      watchBookmarksChangesUseCase: getIt<WatchBookmarksChangesUseCase>(),
    ),
  );
}

void _initHomeDeps() {
  // Data layer
  getIt.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(),
  );
  getIt.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSource(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<NewsRepository>(
    () =>
        NewsRepositoryImpl(getIt<NewsRemoteDataSource>(), getIt<NetworkInfo>()),
  );

  // Domain layer
  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(getIt<CategoriesRepository>()),
  );
  getIt.registerLazySingleton<FetchNewsUseCase>(
    () => FetchNewsUseCase(getIt<NewsRepository>()),
  );
  getIt.registerLazySingleton<ToggleBookmarkUseCase>(
    () => ToggleBookmarkUseCase(getIt<BookmarkRepository>()),
  );
  getIt.registerLazySingleton<SearchNewsUseCase>(
    () => SearchNewsUseCase(getIt<NewsRepository>()),
  );

  // Presentation layer — factory so each BlocProvider gets a fresh instance
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      fetchNewsUseCase: getIt<FetchNewsUseCase>(),
      searchNewsUseCase: getIt<SearchNewsUseCase>(),
      toggleBookmarkUseCase: getIt<ToggleBookmarkUseCase>(),
      getCategoriesUseCase: getIt<GetCategoriesUseCase>(),
      watchBookmarksChangesUseCase: getIt<WatchBookmarksChangesUseCase>(),
      checkIfSavedUseCase: getIt<CheckIfSavedUseCase>(),
    ),
  );
}

void _initProfileDeps() {
  getIt.registerLazySingleton(() => SignOutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(FirebaseAuth.instance),
  );
  getIt.registerLazySingleton(
    () => GetUserDataUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      signOutUseCase: getIt<SignOutUseCase>(),
      getUserDataUseCase: getIt<GetUserDataUseCase>(),
    ),
  );
}

void _initCategoriesDeps() {
  getIt.registerLazySingleton<CategoriesCubit>(
    () => CategoriesCubit(getCategoriesUseCase: getIt<GetCategoriesUseCase>()),
    dispose: (cubit) => cubit.close(),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN-LEVEL INITS (Auth flow, standalone screens)
// These use registerFactory so a fresh instance is created each visit,
// and they don't need a scope because they're inherently short-lived.
// ─────────────────────────────────────────────────────────────────────────────

void initSplash() {
  // SplashCubit is a factory — but the splash route might theoretically be
  // revisited in edge cases. Unregister first to be safe.
  if (getIt.isRegistered<SplashCubit>()) getIt.unregister<SplashCubit>();
  getIt.registerFactory(() => SplashCubit(getIt<AppSharedPrefs>()));
}

void initOnboarding() {
  if (getIt.isRegistered<OnboardingCubit>())
    getIt.unregister<OnboardingCubit>();
  getIt.registerFactory(() => OnboardingCubit());
}

void initLogin() {
  // LoginCubit is a factory — each visit to the login screen gets a fresh cubit.
  // Unregister first: the user can visit login multiple times per app session
  // (first launch, after logout, etc.).
  if (getIt.isRegistered<LoginCubit>()) getIt.unregister<LoginCubit>();
  getIt.registerFactory(
    () => LoginCubit(
      loginUseCase: getIt<LoginUseCase>(),
      signInWithGoogleUseCase: getIt<SignInWithGoogleUseCase>(),
    ),
  );
  // Note: LoginUseCase, SignInWithGoogleUseCase, SignInWithFacebookUseCase
  // are already registered as lazySingletons in _initAuth(). No action needed.
}

void initSignUp() {
  if (getIt.isRegistered<SignUpCubit>()) getIt.unregister<SignUpCubit>();
  getIt.registerFactory(
    () => SignUpCubit(signUpUseCase: getIt<SignupUseCase>()),
  );
}

void disposeSignUp() {
  // SignUpCubit is a factory and disposed by BlocProvider, nothing to unregister here.
}

void initForgetPassword() {
  // ResetPasswordUseCase is registered in _initAuth() — no action needed.
  if (getIt.isRegistered<ForgetPasswordCubit>())
    getIt.unregister<ForgetPasswordCubit>();
  getIt.registerFactory(
    () => ForgetPasswordCubit(resetPasswordUseCase: getIt()),
  );
}

void disposeForgetPassword() {
  // ForgetPasswordCubit is a factory and disposed by BlocProvider, nothing to unregister here.
}

// Language feature lifecycle is managed via BlocProvider inside LanguageView, no setup needed.

void initChangePassword() {
  // ChangePasswordUseCase is registered in _initAuth() — no action needed.
  if (getIt.isRegistered<ChangePasswordCubit>())
    getIt.unregister<ChangePasswordCubit>();
  getIt.registerFactory(
    () => ChangePasswordCubit(changePasswordUseCase: getIt()),
  );
}

void disposeChangePasswordPage() {
  // ChangePasswordCubit is a factory and disposed by BlocProvider, nothing to unregister here.
}
