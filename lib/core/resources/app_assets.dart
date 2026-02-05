const String _baseImagePath = 'assets/images';
const String _baseVectorPath = 'assets/images/vectors';
const String _baseAnimationPath = 'assets/animations';
const String _baseIconPath = 'assets/icons';
const String _baseCategoriesPath = 'assets/cateogories';
const String kTranslationPath = 'assets/translation';

class AppAssets {
  AppAssets._();

  // --- Images ---
  static const String logo = '$_baseVectorPath/logo.svg';
  static const String onboarding = '$_baseImagePath/outboarding.png';
  static const String illustration = '$_baseImagePath/3d-illustration.png';
  static const String facebook = '$_baseImagePath/facebook-logo.png';
  static const String google = '$_baseImagePath/google-logo.png';
  static const String error = '$_baseImagePath/error.png';
  static const String whiteHouse = '$_baseImagePath/white_house.png';
  static const String news2 = '$_baseImagePath/news2.png';
  static const String newsPlaceholder = '$_baseImagePath/news_placeholder.jpg';
  static const String comingSoon = '$_baseAnimationPath/coming-soon.json';

  // --- Categories Svgs ---
  static const String art = '$_baseCategoriesPath/art.svg';
  static const String food = '$_baseCategoriesPath/food.svg';
  static const String entertainment = '$_baseCategoriesPath/gaming.svg';
  static const String politics = '$_baseCategoriesPath/politics.svg';
  static const String science = '$_baseCategoriesPath/science.svg';
  static const String technology = '$_baseCategoriesPath/smarthphone.svg';
  static const String sports = '$_baseCategoriesPath/sports.svg';
  static const String business = '$_baseCategoriesPath/briefcase.svg';


  // --- Lottie Animations (JSON) ---
  static const String loading = '$_baseAnimationPath/loading.json';
  static const String error_404 = '$_baseAnimationPath/error_404.json';
  static const String errorNoInternet =
      '$_baseAnimationPath/error_no_internet.json';
}

class AppIcons {
  AppIcons._();

  static const String book = '$_baseVectorPath/book.svg';
  static const String home = '$_baseIconPath/home.svg';
  static const String search = '$_baseIconPath/search.svg';
  static const String microphone = '$_baseIconPath/microphone.svg';
  static const String user = '$_baseIconPath/user.svg';
  static const String category = '$_baseIconPath/category.svg';
  static const String bookmark = '$_baseIconPath/bookmark.svg';
  static const String delete = '$_baseIconPath/delete.svg';
  static const String bookmarkFilled = '$_baseIconPath/bookmark_filled.svg';
  static const String share = '$_baseIconPath/send.svg';
  static const String back = '$_baseIconPath/back.svg';
  static const String check = '$_baseIconPath/check.svg';
  static const String email = '$_baseIconPath/email.svg';
  static const String lock = '$_baseIconPath/lock.svg';
}
