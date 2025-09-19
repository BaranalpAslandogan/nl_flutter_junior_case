import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jr_case_boilerplate/core/widgets/nav_bar/custom_nav_bar.dart';
import 'package:jr_case_boilerplate/features/auth/services/auth_service.dart';
import 'package:jr_case_boilerplate/features/auth/services/movie_service.dart';
import 'package:jr_case_boilerplate/features/home/widgets/home_movie_list_item.dart';
import 'package:jr_case_boilerplate/features/profile/view/profile_view.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/movie_item_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  User? _currentUser;
  bool _isLoading = true;
  bool _isLoadingMovies = false;
  int _currentNavIndex = 0;
  int _currentPage = 1;
  int _totalPages = 1;
  
  // PageView controller for horizontal swiping
  PageController _pageController = PageController();
  int _currentMovieIndex = 0;
  
  // Film verileri
  List<MovieItem> _movies = [];
  List<MovieItem> _favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Responsive boyutları hesapla
  Map<String, double> _getResponsiveSizes(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Ekran boyutuna göre kategori belirle
    bool isSmallScreen = screenWidth < 360;
    bool isMediumScreen = screenWidth >= 360 && screenWidth < 414;
    bool isLargeScreen = screenWidth >= 414;
    
    return {
      'logoSize': isSmallScreen ? 32 : isMediumScreen ? 36 : 40,
      'titleFontSize': isSmallScreen ? 18 : isMediumScreen ? 20 : 22,
      'descriptionFontSize': isSmallScreen ? 14 : isMediumScreen ? 15 : 16,
      'bottomPadding': screenHeight * 0.02, // Ekran yüksekliğine göre
      'logoBottomPosition': screenHeight * 0.20, // %22
      'contentBottomPosition': screenHeight * 0.17, // %17
      'heartBottomPosition': screenHeight * 0.25, // %23
      'heartRightPosition': screenWidth * 0.028, // %2.8
      'contentLeftPadding': screenWidth * 0.05, // %5
      'contentRightPadding': screenWidth * 0.08, // %23 (kalp butonu için)
    };
  }

  // Tüm verileri yükle
  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Kullanıcı verilerini yükle
      await _loadUserData();
      
      // Film verilerini yükle
      await _loadMoviesData();
    } catch (e) {
      _showSnackBar('Veriler yüklenirken hata oluştu: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadUserData() async {
    try {
      final user = await AuthService.getCurrentUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      print('Kullanıcı verisi yüklenemedi: $e');
    }
  }

  Future<void> _loadMoviesData() async {
    setState(() {
      _isLoadingMovies = true;
    });

    try {
      // Paralel olarak her iki isteği de yap
      final results = await Future.wait([
        MovieService.getMovieList(page: _currentPage),
      ]);

      final moviesResult = results[0];

      // Film listesi sonuçları
      if (moviesResult['success']) {
        final moviesList = moviesResult['movies'] as List;
        _currentPage = moviesResult['currentPage'] ?? 1;
        _totalPages = moviesResult['totalPages'] ?? 1;

        // MovieItem listesine dönüştür
        final movies = moviesList.map((movieJson) => MovieItem.fromJson(movieJson)).toList();

        setState(() {
          _movies = movies;
        });
      } else {
        _showSnackBar(moviesResult['message'], isError: true);
        
        // Unauthorized durumu kontrolü
        if (moviesResult['unauthorized'] == true) {
          _handleUnauthorized();
          return;
        }
      }

    } catch (e) {
      _showSnackBar('Filmler yüklenirken hata oluştu: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMovies = false;
        });
      }
    }
  }

  // Favori durumlarını güncelle
  void _updateFavoriteStatus() {
    // Favori film ID'lerini topla
    final favoriteIds = _favoriteMovies.map((movie) => movie.id).toSet();

    // Ana film listesindeki her film için favori durumunu kontrol et
    setState(() {
      _movies = _movies.map((movie) {
        return movie.copyWith(
          isFavorite: favoriteIds.contains(movie.id),
        );
      }).toList();
    });
  }

  // Filmi favorilere ekle/çıkar
  Future<void> _toggleFavorite(String movieId, int movieIndex) async {
    try {
      // Optimistic UI - önce UI'ı güncelle
      final currentMovie = _movies[movieIndex];
      final newFavoriteStatus = !(currentMovie.isFavorite ?? false);

      setState(() {
        _movies[movieIndex] = currentMovie.copyWith(isFavorite: newFavoriteStatus);
      });

      // API isteğini yap
      final result = await MovieService.toggleFavorite(favoriteId: movieId);

      if (result['success']) {
        // Favori listeyi yeniden yükle
        await _loadFavoriteMovies();
      } else {
        // Hata durumunda eski duruma geri döndür
        setState(() {
          _movies[movieIndex] = currentMovie.copyWith(isFavorite: !newFavoriteStatus);
        });

        _showSnackBar(result['message'], isError: true);

        // Unauthorized kontrolü
        if (result['unauthorized'] == true) {
          _handleUnauthorized();
        }
      }
    } catch (e) {
      // Hata durumunda eski duruma geri döndür
      final currentMovie = _movies[movieIndex];
      setState(() {
        _movies[movieIndex] = currentMovie.copyWith(isFavorite: !(currentMovie.isFavorite ?? false));
      });

      _showSnackBar('Favori durumu değiştirilemedi: ${e.toString()}', isError: true);
    }
  }

  // Sadece favori filmleri yeniden yükle
  Future<void> _loadFavoriteMovies() async {
    try {
      final result = await MovieService.getFavoriteMovies();
      
      if (result['success']) {
        final favoritesList = result['movies'] as List;
        final favoriteMovies = favoritesList.map((movieJson) => MovieItem.fromJson(movieJson)).toList();

        setState(() {
          _favoriteMovies = favoriteMovies;
        });

        _updateFavoriteStatus();
      }
    } catch (e) {
      print('Favori filmler yenilenemedi: $e');
    }
  }

  // Sayfa yenile
  Future<void> _refreshMovies() async {
    await _loadMoviesData();
  }

  // Yetkisiz erişim durumunu handle et
  void _handleUnauthorized() {
    // Login sayfasına yönlendir
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Açıklama detay dialogunu göster
  void _showDescriptionDialog(String title, String description) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        final responsiveSizes = _getResponsiveSizes(context);
        
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık
                Text(
                  title,
                  style: GoogleFonts.instrumentSans(
                    color: Colors.white,
                    fontSize: responsiveSizes['titleFontSize']! - 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Tam açıklama
                SingleChildScrollView(
                  child: Text(
                    description,
                    style: GoogleFonts.instrumentSans(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: responsiveSizes['descriptionFontSize'],
                      height: 1.5,
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
                
                // Kapat butonu
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.8),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Kapat',
                      style: GoogleFonts.instrumentSans(
                        color: Colors.white,
                        fontSize: responsiveSizes['descriptionFontSize'],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // SnackBar göster
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final responsiveSizes = _getResponsiveSizes(context);
        
        if (_isLoading) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.red),
                ],
              ),
            ),
          );
        }

        // Film listesi boşsa
        if (_movies.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.1,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.movie_outlined,
                      color: Colors.white,
                      size: responsiveSizes['logoSize']! + 24,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    Text(
                      'Henüz film bulunmuyor',
                      style: GoogleFonts.instrumentSans(
                        color: Colors.white,
                        fontSize: responsiveSizes['titleFontSize'],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    SizedBox(
                      width: constraints.maxWidth * 0.4,
                      child: ElevatedButton(
                        onPressed: _refreshMovies,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                            vertical: constraints.maxHeight * 0.015,
                          ),
                        ),
                        child: Text(
                          'Yenile',
                          style: TextStyle(
                            fontSize: responsiveSizes['descriptionFontSize'],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Tam ekran PageView
              // PageView.builder(
              //   controller: _pageController,
              //   onPageChanged: (index) {
              //     setState(() {
              //       _currentMovieIndex = index;
              //     });
              //   },
              //   itemCount: _movies.length,
              //   itemBuilder: (context, index) {
              //     final movie = _movies[index];
              //     return _buildMovieScreen(movie, index, responsiveSizes, constraints);
              //   },
              // ),

              HomeMovieListItem(
                movies: _movies,
                pageController: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentMovieIndex = index;
                  });
                },
                onShowDescription: _showDescriptionDialog,
                onToggleFavorite: _toggleFavorite,
                responsiveSizes: responsiveSizes,
                constraints: constraints,
              ),
              // Loading overlay
              if (_isLoadingMovies)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.red),
                      ],
                    ),
                  ),
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
                      currentIndex: 0,
                      onTap: (index) {
                        setState(() {
                          _currentNavIndex = index;
                        });
              
                        switch (index) {
                          case 0:
                            break;
                          case 1:
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProfileView()),
                            );
                            break;
                          default:
                            break;
                        } 
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}