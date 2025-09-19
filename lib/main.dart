import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/features/auth/services/auth_service.dart';
import 'package:jr_case_boilerplate/features/auth/views/login_view.dart';
import 'package:jr_case_boilerplate/features/home/view/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShartFlix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE50914),
          primary: const Color(0xFFE50914),
          secondary: const Color(0xFF5949E6),
          error: const Color(0xFFF47171),

        ),
        // primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'System',
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // 2 saniye splash screen göster
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      final isLoggedIn = await AuthService.isLoggedIn();
      
      if (mounted) {
        if (isLoggedIn) {
          // Kullanıcı giriş yapmış, ana sayfaya yönlendir
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeView()),
          );
        } else {
          // Kullanıcı giriş yapmamış, login sayfasına yönlendir
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        }
      }
    } catch (e) {
      // Hata durumunda login sayfasına yönlendir
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            tileMode: TileMode.clamp,
            center: Alignment.topCenter,
            radius: 1.6,
            colors: [
              Color(0xFFAF0810 ), // Koyu yeşil
              Color(0xFF1F0103), // Daha koyu yeşil
              Color(0xFF090909), // Çok koyu yeşil/siyah
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image(image: Image.asset( 'assets/Icon.png').image,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 32),
            
            // Uygulama adı
            const Text(
              'Shartflix',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            
            // Loading indicator
            // const SizedBox(
            //   width: 30,
            //   height: 30,
            //   child: CircularProgressIndicator(
            //     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            //     strokeWidth: 3,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}