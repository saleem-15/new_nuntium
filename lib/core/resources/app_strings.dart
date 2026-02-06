import 'package:easy_localization/easy_localization.dart';

class AppStrings {
  AppStrings._();

  // Onboarding
  static String get onboardingTitle1 => tr('firstToKnow');
  static String get onboardingSubtitle1 => tr('paragraph');
  static String get onboardingTitle2 => tr('onboarding_title_2');
  static String get onboardingSubtitle2 => tr('onboarding_subtitle_2');
  static String get onboardingTitle3 => tr('onboarding_title_3');
  static String get onboardingSubtitle3 => tr('onboarding_subtitle_3');
  static String get next => tr('next');

  // Welcome
  static String get nuntium => tr('nuntium');
  static String get welcomeBody => tr('paragraph');
  static String get getStarted => tr('getStarted');

  // Login
  static String get loginTitle => tr('welcomeTitle');
  static String get loginSubTitle => tr('loginParagraph');
  static String get emailAdress => tr('emailAddress');
  static String get password => tr('password');
  static String get forgotPassword => tr('forgetPassword');
  static String get signIn => tr('signIn');
  static String get invalidEmail => tr('invalidEmail');
  static String get or => tr('or');
  static String get signInwithGoogle => tr('google');
  static String get signInwithFacebook => tr('facebook');
  static String get dontHaveAccount => tr('dontHaveAnAccount');
  static String get signUp => tr('signUp');
  static String get googleSignInFailed => tr('googleSignInFailed');

  // SignUp
  static String get signUpTitle => tr('signUpTitle');
  static String get signUpSubTitle => tr('signUpParagraph');
  static String get userName => tr('username');
  static String get repeatPassword => tr('confirmPasswordHint');
  static String get haveAnAccount => tr('signUpFooterMessage');

  // Forget Password
  static String get forgetPasswordTitle => tr('forget');
  static String get forgetPasswordSubTitle => tr('forgetParagraph');
  static String get remmeberPassword => tr('remember_password');
  static String get tryAgain => tr('try_again');
  static String get checkYourMail => tr('checkYourMail');
  static String get emailSentDescription => tr('emailSentDescription');
  static String get doneBackToLogin => tr('doneBackToLogin');
  static String get resendLink => tr('resendLink');
  static String get emailSendFailed => tr('emailSendFailed');

  // Create New Password && Change Password Pages
  static String get createNewPasswordTitle => tr('createNewPasswordTitle');
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
  static String get fashionWithEmoji => 'fashionWithEmoji';
  static String get artWithEmoji => 'artWithEmoji';
  static String get natureWithEmoji => 'natureWithEmoji';
  static String get gamingWithEmoji => 'gamingWithEmoji';
  static String get politicsWithEmoji => 'politicsWithEmoji';
  static String get historyWithEmoji => 'historyWithEmoji';
  static String get foodWithEmoji => 'foodWithEmoji';
  static String get animalsWithEmoji => 'animalsWithEmoji';
  static String get lifeWithEmoji => 'lifeWithEmoji';
  static String get sportsWithEmoji => 'sportsWithEmoji';

  // Home Page
  static String get homePageTitle => tr('browse');
  static String get homePageSubTitle => tr('homeParagraph');
  static String get search => tr('search');
  static String get recommendedForYou => tr('recommended_for_you');
  static String get seeAll => tr('seeAll');
  static String get noArticlesFound => tr('No articles found');

  // Article Page
  static String get viewOriginalArticle => tr('viewOriginalArticle');
  static String get originalArticle => tr('originalArticle');
  static String get retry => tr('retry');


  static String get fashion => 'fashion';
  static String get art => 'art';
  static String get nature => 'nature';
  static String get gaming => 'gaming';
  static String get politics => 'politics';
  static String get history => 'history';
  static String get food => 'food';
  static String get animals => 'animals';
  static String get life => 'life';
  static String get sports => 'sports';
  static String get general => 'general';
  static String get business => 'business';
  static String get entertainment => 'entertainment';
  static String get technology => 'technology';
  static String get science => 'science';

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
  static String get signOutFailed => tr('signoutFailed');
  static String get logoutConfirmation => tr('logoutConfirmation');
  static String get yes => tr('logoutConfirmationYes');
  static String get cancel => tr('logoutConfirmationNo');

  // Language Page
  static String get english => tr('english');
  static String get arabic => tr('arabic');

  //Terms And Conditions Page
  static String get termsAndConditionsBody => tr('terms_and_conditions');

  // Privacy And Policy
  static String get privacyPolicyTitle => tr('privacy_policy_title');
  static String get privacyPolicyContent => tr('privacy_policy_content');

  // Validation Messages
  static String get usernameLengthError => tr('usernameLengthError');
  static String get usernameLettersError => tr('usernameLettersError');

  // Error Messages
  static String get errorLoadingNews => tr('errorLoadingNews');
  static String get error => tr("error");

}
