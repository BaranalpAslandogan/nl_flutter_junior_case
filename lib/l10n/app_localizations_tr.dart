// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Shartflix';

  @override
  String get login => 'Giriş Yap';

  @override
  String get register => 'Kayıt Ol';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get name => 'Ad Soyad';

  @override
  String get confirmPassword => 'Şifre Tekrarı';

  @override
  String get forgotPassword => 'Şifremi Unuttum';

  @override
  String get loginTitle => 'Giriş Yap';

  @override
  String get loginSubtitle => 'Kullanıcı bilgilerinle giriş yap';

  @override
  String get createAccount => 'Hesap Oluştur';

  @override
  String get createAccountSubtitle => 'Kullanıcı bilgilerini girerek kaydol';

  @override
  String get dontHaveAccount => 'Bir hesabın yok mu? ';

  @override
  String get alreadyHaveAccount => 'Zaten hesabınız var mı? ';

  @override
  String get or => 'veya';

  @override
  String get emailRequired => 'E-posta adresi gerekli';

  @override
  String get validEmailRequired => 'Geçerli bir e-posta adresi girin';

  @override
  String get passwordRequired => 'Şifre gerekli';

  @override
  String get passwordMinLength => 'Şifre en az 6 karakter olmalı';

  @override
  String get passwordComplexity =>
      'Şifre en az bir büyük harf, bir küçük harf ve bir rakam içermeli';

  @override
  String get confirmPasswordRequired => 'Şifre tekrarı gerekli';

  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String get nameRequired => 'Ad soyad gerekli';

  @override
  String get nameMinLength => 'Ad soyad en az 2 karakter olmalı';

  @override
  String get agreeToTerms =>
      'Kullanım Koşulları ve Gizlilik Politikasını okudum ve kabul ediyorum.';

  @override
  String get mustAgreeToTerms => 'Kullanım koşullarını kabul etmelisiniz';

  @override
  String get home => 'Anasayfa';

  @override
  String get profile => 'Profil';

  @override
  String get profileDetail => 'Profil Detayı';

  @override
  String get uploadPhoto => 'Fotoğraf Yükle';

  @override
  String get uploadPhotoSubtitle =>
      'Profil fotoğrafı için görsel\nyükleyebilirsin';

  @override
  String get selectPhoto => 'Fotoğraf Seç';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get continueText => 'Devam Et';

  @override
  String get skip => 'Atla';

  @override
  String get addPhoto => 'Fotoğraf Ekle';

  @override
  String get myLikes => 'Beğendiklerim';

  @override
  String get noFavoriteMovies => 'Henüz favori filminiz yok.';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get logoutConfirmation =>
      'Uygulamadan çıkış yapmak istediğinizden emin misiniz?';

  @override
  String get cancel => 'İptal';

  @override
  String get limitedOffer => 'Sınırlı Teklif';

  @override
  String get limitedOfferDescription =>
      'Jeton paketini seçerek bonus kazanın ve yeni\nbölümlerin kilidini açın!';

  @override
  String get bonusesYouWillGet => 'Alacağınız Bonuslar';

  @override
  String get premiumAccount => 'Premium\nHesap';

  @override
  String get more => 'Daha\nFazla';

  @override
  String get priority => 'Öne\nÇıkarma';

  @override
  String get moreVariety => 'Daha\nFazla Değeni';

  @override
  String get selectTokenPackage => 'Kilidi açmak için bir jeton paketi seçin';

  @override
  String get tokens => 'Jeton';

  @override
  String get weekly => 'haftalık';

  @override
  String get showAllTokens => 'Tüm Jetonları Gör';

  @override
  String get allTokenPackagesSoon => 'Tüm jeton paketleri yakında!';

  @override
  String get noMoviesYet => 'Henüz film bulunmuyor';

  @override
  String get refresh => 'Yenile';

  @override
  String get user => 'Kullanıcı';

  @override
  String get noId => 'ID Yok';

  @override
  String get errorPrefix => 'Hata: ';

  @override
  String get photoSelectionError => 'Fotoğraf seçilirken hata oluştu';

  @override
  String get pleaseSelectPhoto => 'Lütfen önce bir fotoğraf seçin';

  @override
  String get uploadError => 'Yükleme sırasında hata oluştu';

  @override
  String unexpectedError(String error) {
    return 'Beklenmeyen bir hata oluştu: $error';
  }

  @override
  String connectionError(String error) {
    return 'Bağlantı hatası: $error';
  }

  @override
  String get loginSuccessful => 'Giriş başarılı!';

  @override
  String get registrationSuccessful =>
      'Kayıt başarılı! Şimdi giriş yapabilirsiniz.';

  @override
  String get photoUploadSuccessful => 'Fotoğraf başarıyla yüklendi!';
}
