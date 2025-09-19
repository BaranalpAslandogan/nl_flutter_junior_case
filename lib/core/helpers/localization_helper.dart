// lib/core/utils/localization_helper.dart - Anlık değişim versiyonu

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class LocalizationHelper {
  static const String _languageKey = 'selected_language';
  
  static const List<Locale> supportedLocales = [
    Locale('tr'),
    Locale('en'),
  ];
  
  static const Locale defaultLocale = Locale('tr');
  
  static Future<Locale> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);
    
    if (languageCode != null) {
      return Locale(languageCode);
    }
    
    return defaultLocale;
  }
  
  static Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
  }
  
  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'tr':
        return 'Türkçe';
      case 'en':
        return 'English';
      default:
        return 'Türkçe';
    }
  }
  
  // Anlık dil değişimi - import etmeden main.dart'a erişim
  static Future<void> changeLanguage(Locale newLocale) async {
    await saveLocale(newLocale);
    
    // Global navigatorKey üzerinden erişim
    try {
      // MyApp'in static metodunu çağır - bu kısım main.dart'da tanımlanmalı
      _callMyAppSetLocale(newLocale);
    } catch (e) {
      print('Dil değiştirme hatası: $e');
    }
  }
  
  // Bu metod main.dart'da implement edilecek
  static void Function(Locale)? _myAppSetLocale;
  
  static void setMyAppCallback(void Function(Locale) callback) {
    _myAppSetLocale = callback;
  }
  
  static void _callMyAppSetLocale(Locale locale) {
    _myAppSetLocale?.call(locale);
  }
  
  static void showLanguageModal(
    BuildContext context,
    Locale currentLocale,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Dil Seçin / Select Language',
              style: GoogleFonts.instrumentSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...supportedLocales.map((locale) => 
              _buildLanguageOption(context, locale, currentLocale),
            ).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  static Widget _buildLanguageOption(
    BuildContext context,
    Locale locale,
    Locale currentLocale,
  ) {
    final isSelected = currentLocale.languageCode == locale.languageCode;
    
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
        await changeLanguage(locale);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.withOpacity(0.2) : Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: isSelected 
            ? Border.all(color: Colors.red, width: 2)
            : null,
        ),
        child: Row(
          children: [
            Text(
              locale.languageCode == 'tr' ? '🇹🇷' : '🇺🇸',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                getLanguageName(locale),
                style: GoogleFonts.instrumentSans(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.red,
                size: 24,
              ),
          ],
        ),  
      ),
    );
  }
  
  static Widget buildLanguageButton(
    BuildContext context,
    Locale? currentLocale,
    Function(Locale)? onLanguageChanged,
  ) {
    // Şu anki dili al - Localizations.localeOf kullan
    final actualLocale = Localizations.localeOf(context);
    
    return GestureDetector(
      onTap: () => showLanguageModal(context, actualLocale),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              actualLocale.languageCode == 'tr' ? '🇹🇷' : '🇺🇸',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}