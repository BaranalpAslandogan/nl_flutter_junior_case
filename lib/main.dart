// lib/main.dart - Anlık dil değişimi versiyonu

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jr_case_boilerplate/core/helpers/localization_helper.dart';
import 'package:jr_case_boilerplate/features/auth/services/auth_service.dart';
import 'package:jr_case_boilerplate/features/auth/views/login_view.dart';
import 'package:jr_case_boilerplate/features/home/view/home_view.dart';
import 'package:jr_case_boilerplate/features/splash/view/splash_view.dart';
import 'package:jr_case_boilerplate/l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = LocalizationHelper.defaultLocale;

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
    
    // LocalizationHelper'a callback ver
    LocalizationHelper.setMyAppCallback((locale) {
      if (mounted) {
        setState(() {
          _locale = locale;
        });
      }
    });
  }

  Future<void> _loadSavedLocale() async {
    final savedLocale = await LocalizationHelper.getSavedLocale();
    if (mounted) {
      setState(() {
        _locale = savedLocale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShartFlix',
      debugShowCheckedModeBanner: false,
      
      // Localization ayarları
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LocalizationHelper.supportedLocales,
      
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE50914),
          primary: const Color(0xFFE50914),
          secondary: const Color(0xFF5949E6),
          error: const Color(0xFFF47171),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'System',
      ),
      
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginView(),
        '/home': (context) => const HomeView(),
      },
    );
  }
}