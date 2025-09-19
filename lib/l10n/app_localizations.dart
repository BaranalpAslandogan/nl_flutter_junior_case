import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Shartflix'**
  String get appTitle;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// Login page title
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// Login page subtitle
  ///
  /// In en, this message translates to:
  /// **'Login with your credentials'**
  String get loginSubtitle;

  /// Create account title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Create account subtitle
  ///
  /// In en, this message translates to:
  /// **'Register by entering user information'**
  String get createAccountSubtitle;

  /// Text before register link
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// Text before login link
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// Or text between options
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// Email required validation message
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Valid email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validEmailRequired;

  /// Password required validation message
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Password minimum length validation
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Password complexity validation
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter, one lowercase letter and one number'**
  String get passwordComplexity;

  /// Confirm password required validation
  ///
  /// In en, this message translates to:
  /// **'Password confirmation is required'**
  String get confirmPasswordRequired;

  /// Passwords mismatch validation
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Name required validation
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// Name minimum length validation
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMinLength;

  /// Terms agreement checkbox text
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the Terms of Use and Privacy Policy.'**
  String get agreeToTerms;

  /// Terms agreement validation message
  ///
  /// In en, this message translates to:
  /// **'You must agree to the terms of use'**
  String get mustAgreeToTerms;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Profile navigation label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Profile detail page title
  ///
  /// In en, this message translates to:
  /// **'Profile Detail'**
  String get profileDetail;

  /// Upload photo title
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// Upload photo subtitle
  ///
  /// In en, this message translates to:
  /// **'You can upload an image\nfor your profile photo'**
  String get uploadPhotoSubtitle;

  /// Select photo modal title
  ///
  /// In en, this message translates to:
  /// **'Select Photo'**
  String get selectPhoto;

  /// Camera option text
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Gallery option text
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Add photo button text
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// My likes section title
  ///
  /// In en, this message translates to:
  /// **'My Likes'**
  String get myLikes;

  /// No favorite movies message
  ///
  /// In en, this message translates to:
  /// **'No favorite movies yet.'**
  String get noFavoriteMovies;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Limited offer button text
  ///
  /// In en, this message translates to:
  /// **'Limited Offer'**
  String get limitedOffer;

  /// Limited offer description
  ///
  /// In en, this message translates to:
  /// **'Choose a token package to earn bonus and unlock new chapters!'**
  String get limitedOfferDescription;

  /// Bonuses section title
  ///
  /// In en, this message translates to:
  /// **'Bonuses You Will Get'**
  String get bonusesYouWillGet;

  /// Premium account bonus
  ///
  /// In en, this message translates to:
  /// **'Premium\nAccount'**
  String get premiumAccount;

  /// More likes bonus
  ///
  /// In en, this message translates to:
  /// **'More\nLikes'**
  String get more;

  /// Priority queue bonus
  ///
  /// In en, this message translates to:
  /// **'Priority\nQueue'**
  String get priority;

  /// More variety bonus
  ///
  /// In en, this message translates to:
  /// **'More\nVariety'**
  String get moreVariety;

  /// Token package selection instruction
  ///
  /// In en, this message translates to:
  /// **'Select a token package to unlock'**
  String get selectTokenPackage;

  /// Tokens text
  ///
  /// In en, this message translates to:
  /// **'Tokens'**
  String get tokens;

  /// Weekly billing text
  ///
  /// In en, this message translates to:
  /// **'weekly'**
  String get weekly;

  /// Show all tokens button
  ///
  /// In en, this message translates to:
  /// **'Show All Tokens'**
  String get showAllTokens;

  /// All token packages snackbar message
  ///
  /// In en, this message translates to:
  /// **'All token packages coming soon!'**
  String get allTokenPackagesSoon;

  /// No movies message
  ///
  /// In en, this message translates to:
  /// **'No movies found yet'**
  String get noMoviesYet;

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Default user name
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No ID text
  ///
  /// In en, this message translates to:
  /// **'No ID'**
  String get noId;

  /// Error message prefix
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorPrefix;

  /// Photo selection error message
  ///
  /// In en, this message translates to:
  /// **'Error occurred while selecting photo'**
  String get photoSelectionError;

  /// Please select photo message
  ///
  /// In en, this message translates to:
  /// **'Please select a photo first'**
  String get pleaseSelectPhoto;

  /// Upload error message
  ///
  /// In en, this message translates to:
  /// **'Error occurred during upload'**
  String get uploadError;

  /// Unexpected error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred: {error}'**
  String unexpectedError(String error);

  /// Connection error message
  ///
  /// In en, this message translates to:
  /// **'Connection error: {error}'**
  String connectionError(String error);

  /// Login success message
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// Registration success message
  ///
  /// In en, this message translates to:
  /// **'Registration successful! You can now login.'**
  String get registrationSuccessful;

  /// Photo upload success message
  ///
  /// In en, this message translates to:
  /// **'Photo uploaded successfully!'**
  String get photoUploadSuccessful;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
