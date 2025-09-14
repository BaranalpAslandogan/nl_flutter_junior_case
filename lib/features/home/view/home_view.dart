import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/widgets/nav_bar/custom_nav_bar.dart';
import 'package:jr_case_boilerplate/features/auth/services/auth_service.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
      body: SafeArea(
        child: Column(
          children: [
            // Ana içerik alanı - SingleChildScrollView kullanıyoruz
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero section
                    Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black87,
                            Colors.black,
                          ],
                          stops: [0.0, 0.7, 1.0],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Background image
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://i.imgur.com/xMkDVab.jpeg',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Content overlay
                          Positioned(
                            bottom: 40,
                            left: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Netflix logo
                                Container(
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
                                const SizedBox(height: 12),
                                const Text(
                                  'Son Ana Kadar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Birbirine derindin bağlı iki çocukluk\narkadaşı olan Sydney ve Devam Oku',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Navbar - Sabit pozisyonda
            CustomNavbar(
              currentIndex: _currentNavIndex,
              onTap: (index) {
                setState(() {
                  _currentNavIndex = index;
                });
                
                if (index == 0) {
                  _showSnackBar('Anasayfadasınız');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMovieRow(List<String> imageUrls) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _showSnackBar('Film detayı yakında eklenecek');
            },
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imageUrls[index]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
                child: const Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}