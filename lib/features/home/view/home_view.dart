import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/extensions/assets/app_icons_ext.dart';
import 'package:jr_case_boilerplate/core/widgets/nav_bar/custom_nav_bar.dart';
import 'package:jr_case_boilerplate/features/auth/services/auth_service.dart';
import 'package:jr_case_boilerplate/features/profile/view/profile_view.dart';
import '../../../core/models/user_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  User? _currentUser;
  bool _isLoading = true;
  int _currentNavIndex = 0;
  
  // PageView controller for horizontal swiping
  PageController _pageController = PageController();
  int _currentMovieIndex = 0;
  
  // Film verileri
  final List<Map<String, String>> _movies = [
    {
      'title': 'Son Ana Kadar',
      'description': 'Birbirine derinden bağlı iki çocukluk\narkadaşı olan Sydney ve Devam Oku',
      'image': 'https://i.imgur.com/xMkDVab.jpeg',
    },
    {
      'title': 'Aşk Hikayesi',
      'description': 'İki kalbin birbirini bulması ve\naşkın gücünü keşfetmesi',
      'image': 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=800&h=1200&fit=crop',
    },
    {
      'title': 'Macera Zamanı',
      'description': 'Sınırları aşan bir macera ve\nkeşfedilmeyi bekleyen gizemler',
      'image': 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800&h=1200&fit=crop',
    },
    {
      'title': 'Gizli Dünya',
      'description': 'Görünmeyen dünyanın sırları ve\nbilinmezlere doğru yolculuk',
      'image': 'https://images.unsplash.com/photo-1489599558337-2c6b9f0e0d18?w=800&h=1200&fit=crop',
    },
    {
      'title': 'Zaman Yolcusu',
      'description': 'Geçmiş ve gelecek arasındaki\nmüthiş bir zaman yolculuğu',
      'image': 'https://images.unsplash.com/photo-1518676590629-3dcbd9c5a5c9?w=800&h=1200&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await AuthService.getCurrentUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Tam ekran PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentMovieIndex = index;
              });
            },
            itemCount: _movies.length,
            itemBuilder: (context, index) {
              final movie = _movies[index];
              return _buildMovieScreen(movie);
            },
          ),
          
          // Transparan Bottom Navbar - En üstte
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: SafeArea(
                child: CustomNavbar(
                  currentIndex: _currentNavIndex,
                  onTap: (index) {
                    setState(() {
                      _currentNavIndex = index;
                    });
          
                    switch (index) {
                      case 0:
                        _showSnackBar('Anasayfadasınız');
                        break;
                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileView()),
                        );
                        break;
                      default:
                        _showSnackBar('Anasayfadasınız');
                        break;
                    } 
                  },
                ),
              ),
            ),
          ),
          
          // Sayfa göstergesi (dots)
          // Positioned(
          //   right: 20,
          //   top: MediaQuery.of(context).size.height * 0.5,
          //   child: Column(
          //     children: List.generate(
          //       _movies.length,
          //       (index) => Container(
          //         width: 8,
          //         height: 8,
          //         margin: const EdgeInsets.symmetric(vertical: 4),
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: _currentMovieIndex == index
          //               ? Colors.white
          //               : Colors.white.withOpacity(0.4),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildMovieScreen(Map<String, String> movie) {
     return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image - tam ekran
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(movie['image']!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Gradient overlay - daha yumuşak geçiş
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
          
          // Content overlay - Netflix logosu
          Positioned(
            bottom: 175, // Navbar için boşluk bırak
            left: 20,
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'N',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Film bilgileri
          Positioned(
            bottom: 140,
            left: 80,
            right: 90, // Kalp butonu için alan bırak
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  movie['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
                
                // Film açıklaması
                Text(
                  movie['description']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.4,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Kalp butonu - ayrı positioned
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.230,
            right: MediaQuery.of(context).size.width * 0.028,
            child: FavoriteButton(
                    isLiked: true,
                    onTap: () {
                      setState(() {
                        // _movieLikes[movieIndex] = !(_movieLikes[movieIndex] ?? false);
                      });
                      
                      // final isLiked = _movieLikes[movieIndex] ?? false;
                      // _showSnackBar(
                      //   isLiked ? '${movie['title']} beyaz kalple beğenildi!' : '${movie['title']} beğenisi kaldırıldı!',
                      //   isError: false,
                      // );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}