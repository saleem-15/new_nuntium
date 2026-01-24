import 'package:easy_localization/easy_localization.dart';

class AppStrings {
  AppStrings._();

  // Onboarding
  static String get onboardingTitle1 => tr('firstToKnow');
  static String get onboardingSubtitle1 => tr('paragraph');

  // ملاحظة: ملف JSON لا يحتوي حالياً على عناوين فرعية لـ Onboarding 2 و 3
  // سأبقيها كما هي حالياً لتضيفها لاحقاً في ملف JSON
  static String get onboardingTitle2 => tr('onboarding_title_2');
  static String get onboardingSubtitle2 => tr('onboarding_subtitle_2');

  static String get onboardingTitle3 => tr('onboarding_title_3');
  static String get onboardingSubtitle3 => tr('onboarding_subtitle_3');

  static String get next => tr('next');

  // Welcome
  static String get nuntium =>
      tr('nuntium'); // تأكد من إضافة هذا المفتاح لملف JSON
  static String get welcomeBody => tr('paragraph');
  static String get getStarted => tr('getStarted');

  // Login
  static String get loginTitle => tr('welcomeTitle');
  static String get loginSubTitle => tr('loginParagraph');
  static String get emailAdress => tr('emailAddress');
  static String get password => tr('password');
  static String get forgotPassword => tr('forgetPassword');
  static String get signIn => tr('signIn');
  static String get or => tr('or');
  static String get signInwithGoogle => tr('google');
  static String get signInwithFacebook => tr('facebook');
  static String get dontHaveAccount => tr('dontHaveAnAccount');
  static String get signUp => tr('signUp');

  // SignUp
  static String get signUpTitle => tr('signUpTitle');
  static String get signUpSubTitle => tr('signUpParagraph');
  static String get userName => tr('username');
  static String get repeatPassword => tr('confirmPasswordHint');
  static String get haveAnAccount => tr('signUpFooterMessage');

  // Forget Password
  static String get forgetPasswordTitle => tr('forget');
  static String get forgetPasswordSubTitle => tr('forgetParagraph');
  static String get remmeberPassword =>
      tr('remember_password'); // غير موجود في JSON
  static String get tryAgain => tr('try_again'); // غير موجود في JSON

  // Create New Password && Change Password Pages
  // غير موجود في JSON
  static String get createNewPasswordTitle => tr('createNewPasswordTitle');
  // غير موجود في JSON
  static String get createNewPasswordSubTitle =>
      tr('createNewPasswordSubTitle');
  static String get newPassword => tr('newPasswordHint');
  static String get repeateNewPassword => tr('repeatNewPassword');
  static String get currentPassword => tr('currentPassword');
  static String get requiredField => tr('requiredField');
  static String get passwordsDontMatch => tr('passwordsDontMatch');
  static String get tooShort => tr('tooShort');

  // Verification Code
  static String get verificatonCodeTitle => tr('verificationCodeTitle');
  static String get verificatonCodeSubTitle => tr('verificationCodeParagraph');
  static String get confirm => tr('confirm');
  static String get didntReciveEmail => tr('didntRecieveEmail?');
  static String get sendAgain => tr('sendAgain');

  // Select favorite topics
  static String get selectFavoriteTopicsTitle =>
      tr('selectYourFavouriteTopics');
  static String get selectFavoriteTopicsSubTitle =>
      tr('selectYourFavouriteTopicsParagraph');
  // Topics (With Emoji)
  static String get fashionWithEmoji => tr('fashionWithEmoji');
  static String get artWithEmoji => tr('artWithEmoji');
  static String get natureWithEmoji => tr('natureWithEmoji');
  static String get gamingWithEmoji => tr('gamingWithEmoji');
  static String get politicsWithEmoji => tr('politicsWithEmoji');
  static String get historyWithEmoji => tr('historyWithEmoji');
  static String get foodWithEmoji => tr('foodWithEmoji');
  static String get animalsWithEmoji => tr('animalsWithEmoji');
  static String get lifeWithEmoji => tr('lifeWithEmoji');
  static String get sportsWithEmoji => tr('sportsWithEmoji');

  // Home Page
  static String get homePageTitle => tr('browse');
  static String get homePageSubTitle => tr('homeParagraph');
  static String get search => tr('search');
  static String get recommendedForYou =>
      tr('recommended_for_you'); // غير موجود في JSON
  static String get seeAll => tr('seeAll'); // غير موجود في JSON
  static String get noArticlesFound => tr('No articles found');

  static String get fashion => tr('fashion');
  static String get art => tr('art');
  static String get nature => tr('nature');
  static String get gaming => tr('gaming');
  static String get politics => tr('politics');
  static String get history => tr('history');
  static String get food => tr('food');
  static String get animals => tr('animals');
  static String get life => tr('life');
  static String get sports => tr('sports');
  static String get random => tr('random');

  // Categories Page
  static String get categoriesPageTitle => tr('categories');
  static String get categoriesPageSubTitle => tr('categoriesParagraph');

  // Bookmarks Page
  static String get bookmarksPageTitle => tr('bookmarks');
  static String get delete => tr("Delete");
  static String get bookmarksPageSubTitle => tr('bookmarksParagraph');
  static String get noSavedArticles => tr('youHaventSavedAnyArticles');

  // Profile Page
  static String get profile => tr('profile');
  static String get notifications => tr('notifications');
  static String get language => tr('language');
  static String get changePassword => tr('changePassword');
  static String get privacy => tr('privacy');
  static String get termsAndConditions => tr('termsAndConditions');
  static String get signOut => tr('signout');

  // Language Page
  static String get english => tr('english');
  static String get arabic => tr('arabic');

  //Terms And Conditions Page
  static String get termsAndConditionsBody => tr('terms_and_conditions');

  // Privacy And Policy
  static String get privacyPolicyTitle => tr('privacy_policy_title');
  static String get privacyPolicyContent => tr('privacy_policy_content');
}
