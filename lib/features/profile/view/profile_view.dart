// profile_view.dart

import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/models/movie_item_model.dart';
import 'package:jr_case_boilerplate/core/widgets/bottom_sheet/offer_bottom_sheet.dart';
import 'package:jr_case_boilerplate/core/widgets/nav_bar/custom_nav_bar.dart';
import 'package:jr_case_boilerplate/features/auth/services/auth_service.dart';
import 'package:jr_case_boilerplate/features/auth/services/movie_service.dart';
import 'package:jr_case_boilerplate/features/auth/views/login_view.dart';
import 'package:jr_case_boilerplate/features/upload_photo/view/upload_photo_view.dart';
import '../../../core/models/user_model.dart';
import 'dart:io';

// Eklenen import

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User? _currentUser;
  bool _isLoading = true;
  int _currentNavIndex = 1;
  File? _profileImage;
  
  // Yeni eklenen değişkenler
  List<MovieItem> _favoriteMovies = [];
  bool _isMoviesLoading = true;
  String? _moviesError;

  @override
  void initState() {
    super.initState();
    _loadUserDataAndMovies();
  }

  // Hem kullanıcı bilgilerini hem de filmleri yüklemek için yeni bir metot
  Future<void> _loadUserDataAndMovies() async {
    setState(() {
      _isLoading = true;
      _isMoviesLoading = true;
    });
    try {
      final user = await AuthService.getProfile();
      User _user = user['user'];
      setState(() {
        _currentUser = _user;
        _isLoading = false;
      });
      // Favori filmleri yükle
      await _loadFavoriteMovies();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isMoviesLoading = false;
        });
      }
    }
  }

  Future<void> _loadFavoriteMovies() async {
    final result = await MovieService.getFavoriteMovies();
    if (mounted) {
      setState(() {
        if (result['success']) {
          final List moviesData = result['movies'];
          _favoriteMovies = moviesData.map((json) => MovieItem.fromJson(json)).toList();
          _moviesError = null;
        } else {
          _moviesError = result['message'];
          _favoriteMovies = [];
        }
        _isMoviesLoading = false;
      });
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
      builder: (context) => const LimitedOfferPopup(),
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
      body: Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            tileMode: TileMode.clamp,
            center: Alignment.topCenter,
            radius: 1.6,
            colors: [
              Color(0xFFAF0810 ),
              Color(0xFF1F0103),
              Color(0xFF090909),
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProfileInfo(),
                      Divider(thickness: 1, color: Colors.white.withOpacity(0.15),),
                      const SizedBox(height: 30),
                      _buildLikedSection(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              CustomNavbar(
                currentIndex: _currentNavIndex,
                onTap: (index) {
                  setState(() {
                    _currentNavIndex = index;
                  });
                  if (index == 0) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(image: Image.asset( 'assets/Gem.png').image,
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 6),
                  const Text(
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
            backgroundImage: 
                NetworkImage( _currentUser?.photoUrl ??
                   'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face',
                  ) as ImageProvider,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentUser?.name ?? 'Kullanıcı',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${_currentUser?.id?.substring(0, 6) ?? "ID Yok"}',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
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
                    // Fotoğraf yüklendikten sonra profil verisini de yenile
                    _refreshProfileData();
                  }
                },
                label: const Text(
                  'Fotoğraf Ekle',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.09),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.27, MediaQuery.of(context).size.width * 0.095),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),

          Expanded(child: GestureDetector(
            onTap: _showLogoutDialog,
            child: Container(
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.logout,
                color: Colors.white70,
                size: 28,
              ),
            ),
          ),)
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
        _isMoviesLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.red),
              )
            : _favoriteMovies.isEmpty
                ? Center(
                    child: Text(
                      _moviesError ?? 'Henüz favori filminiz yok.',
                      style: TextStyle(color: Colors.grey[400]),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _favoriteMovies.length,
                      itemBuilder: (context, index) {
                        final movie = _favoriteMovies[index];
                        return _buildMovieCard(movie);
                      },
                    ),
                  ),
      ],
    );
  }

  Widget _buildMovieCard(MovieItem movie) {
    return GestureDetector(
      onTap: () {
        _showSnackBar('${movie.title} detayı yakında eklenecek');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(movie.posterUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  movie.description,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Profil verisini backend'den yenilemek için
  Future<void> _refreshProfileData() async {
    final result = await AuthService.refreshProfile();
    if (mounted) {
      if (result['success']) {
        setState(() {
          _currentUser = result['user'];
        });
        _showSnackBar(result['message']);
      } else {
        _showSnackBar(result['message'], isError: true);
      }
    }
  }
}