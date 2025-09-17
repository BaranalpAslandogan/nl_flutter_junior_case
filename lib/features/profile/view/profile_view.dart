import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/widgets/bottom_sheet/offer_bottom_sheet.dart';
import 'package:jr_case_boilerplate/core/widgets/nav_bar/custom_nav_bar.dart';
import 'package:jr_case_boilerplate/features/auth/services/auth_service.dart';
import 'package:jr_case_boilerplate/features/auth/views/login_view.dart';
import 'package:jr_case_boilerplate/features/upload_photo/view/upload_photo_view.dart';
import '../../../core/models/user_model.dart';
import 'dart:io';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User? _currentUser;
  bool _isLoading = true;
  int _currentNavIndex = 1; // Profil sekmesi aktif
  File? _profileImage; // Profil fotoğrafı için

  // Örnek beğenilen filmler
  final List<Map<String, String>> _likedMovies = [
    {
      'title': 'Love Again',
      'subtitle': 'Aşk Yeniden',
      'company': 'Sony',
      'image': 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=300&h=400&fit=crop',
    },
    {
      'title': 'After Lives',
      'subtitle': 'Başka Bir Hayatta',
      'company': 'A24',
      'image': 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=300&h=400&fit=crop',
    },
    {
      'title': 'Anyone But You',
      'subtitle': 'Senden Başka',
      'company': 'Columbia',
      'image': 'https://images.unsplash.com/photo-1489599558337-2c6b9f0e0d18?w=300&h=400&fit=crop',
    },
    {
      'title': 'Culpa Mía',
      'subtitle': 'Culpa mía',
      'company': 'Netflix',
      'image': 'https://images.unsplash.com/photo-1518676590629-3dcbd9c5a5c9?w=300&h=400&fit=crop',
    },
  ];

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

  // Sınırlı Teklif Popup'ını göstermek için fonksiyon
  void _showLimitedOfferPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LimitedOfferPopup(), // Kendi widget'ınızı kullanın
    );
  }

  // Çıkış dialog'unu göstermek için fonksiyon
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Çıkış Yap',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Uygulamadan çıkış yapmak istediğinizden emin misiniz?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: const Text(
                'İptal',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Çıkış Yap',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await AuthService.logout();

                _showSnackBar('Başarıyla çıkış yapıldı');

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
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
            // Header
            _buildHeader(),

            // Ana içerik
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profil bilgileri
                    _buildProfileInfo(),

                    const SizedBox(height: 30),

                    // Beğendiklerim bölümü
                    _buildLikedSection(),

                    // Alt boşluk
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Bottom Navbar
            CustomNavbar(
              currentIndex: _currentNavIndex,
              onTap: (index) {
                setState(() {
                  _currentNavIndex = index;
                });

                if (index == 0) {
                  // Anasayfaya dön
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: _showLimitedOfferPopup,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Sınırlı Teklif',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
                radius: 32,
                backgroundColor: Colors.grey[800],
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const NetworkImage(
                        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
                      ) as ImageProvider,
              ),
              const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kullanıcı adı
              Text(
                _currentUser?.name ?? 'Ayca Aydoğan',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              // Kullanıcı ID
              Text(
                'ID: ${_currentUser?.email.hashCode.toString().substring(0, 6) ?? "245677"}',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),

              // const SizedBox(height: 20),

              // Butonlar
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Fotoğraf Ekle butonu
              //     ElevatedButton.icon(
              //       onPressed: () async {
              //         final result = await Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => const UploadPhotoView(),
              //           ),
              //         );

              //         if (result != null && result is File) {
              //           setState(() {
              //             _profileImage = result;
              //           });
              //           _showSnackBar('Profil fotoğrafı güncellendi!');
              //         }
              //       },
              //       icon: const Icon(Icons.camera_alt, color: Colors.white),
              //       label: const Text(
              //         'Fotoğraf Ekle',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.grey[800],
              //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(25),
              //         ),
              //       ),
              //     ),

              //     Çıkış Yap butonu
              //     ElevatedButton.icon(
              //       onPressed: _showLogoutDialog,
              //       icon: const Icon(Icons.logout, color: Colors.white),
              //       label: const Text(
              //         'Çıkış Yap',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.red[700],
              //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(25),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
          
          const SizedBox(width: 10),

          ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadPhotoView(),
                        ),
                      );

                      if (result != null && result is File) {
                        setState(() {
                          _profileImage = result;
                        });
                        _showSnackBar('Profil fotoğrafı güncellendi!');
                      }
                    },
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: const Text(
                      'Fotoğraf Ekle',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
        ],
      ),
    );
  }

  Widget _buildLikedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Beğendiklerim',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Film kartları - 2x2 grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemCount: _likedMovies.length,
            itemBuilder: (context, index) {
              final movie = _likedMovies[index];
              return _buildMovieCard(movie);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieCard(Map<String, String> movie) {
    return GestureDetector(
      onTap: () {
        _showSnackBar('${movie['title']} detayı yakında eklenecek');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(movie['image']!),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.8),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  movie['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  movie['subtitle']!,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  movie['company']!,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}