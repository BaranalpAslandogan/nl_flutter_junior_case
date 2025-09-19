// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Shartflix';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginSubtitle => 'Login with your credentials';

  @override
  String get createAccount => 'Create Account';

  @override
  String get createAccountSubtitle => 'Register by entering user information';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get or => 'or';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get validEmailRequired => 'Please enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get passwordComplexity =>
      'Password must contain at least one uppercase letter, one lowercase letter and one number';

  @override
  String get confirmPasswordRequired => 'Password confirmation is required';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get nameMinLength => 'Name must be at least 2 characters';

  @override
  String get agreeToTerms =>
      'I have read and agree to the Terms of Use and Privacy Policy.';

  @override
  String get mustAgreeToTerms => 'You must agree to the terms of use';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get profileDetail => 'Profile Detail';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get uploadPhotoSubtitle =>
      'You can upload an image\nfor your profile photo';

  @override
  String get selectPhoto => 'Select Photo';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get continueText => 'Continue';

  @override
  String get skip => 'Skip';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get myLikes => 'My Likes';

  @override
  String get noFavoriteMovies => 'No favorite movies yet.';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get limitedOffer => 'Limited Offer';

  @override
  String get limitedOfferDescription =>
      'Choose a token package to earn bonus and unlock new chapters!';

  @override
  String get bonusesYouWillGet => 'Bonuses You Will Get';

  @override
  String get premiumAccount => 'Premium\nAccount';

  @override
  String get more => 'More\nLikes';

  @override
  String get priority => 'Priority\nQueue';

  @override
  String get moreVariety => 'More\nVariety';

  @override
  String get selectTokenPackage => 'Select a token package to unlock';

  @override
  String get tokens => 'Tokens';

  @override
  String get weekly => 'weekly';

  @override
  String get showAllTokens => 'Show All Tokens';

  @override
  String get allTokenPackagesSoon => 'All token packages coming soon!';

  @override
  String get noMoviesYet => 'No movies found yet';

  @override
  String get refresh => 'Refresh';

  @override
  String get user => 'User';

  @override
  String get noId => 'No ID';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get photoSelectionError => 'Error occurred while selecting photo';

  @override
  String get pleaseSelectPhoto => 'Please select a photo first';

  @override
  String get uploadError => 'Error occurred during upload';

  @override
  String unexpectedError(String error) {
    return 'An unexpected error occurred: $error';
  }

  @override
  String connectionError(String error) {
    return 'Connection error: $error';
  }

  @override
  String get loginSuccessful => 'Login successful!';

  @override
  String get registrationSuccessful =>
      'Registration successful! You can now login.';

  @override
  String get photoUploadSuccessful => 'Photo uploaded successfully!';
}
