import 'package:flutter/material.dart';
import 'package:jr_case_boilerplate/core/extensions/assets/app_icons_ext.dart';
import 'package:jr_case_boilerplate/core/widgets/nav_bar/custom_nav_bar.dart';
import 'package:jr_case_boilerplate/features/auth/services/auth_service.dart';
import 'package:jr_case_boilerplate/features/auth/services/movie_service.dart';
import 'package:jr_case_boilerplate/features/home/widgets/network_image.dart';
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

      // Favori filmler sonuçları
      // if (favoritesResult['success']) {
      //   final favoritesList = favoritesResult['movies'] as List;
      //   final favoriteMovies = favoritesList.map((movieJson) => MovieItem.fromJson(movieJson)).toList();

      //   setState(() {
      //     _favoriteMovies = favoriteMovies;
      //   });
      // } else {
      //   print('Favori filmler yüklenemedi: ${favoritesResult['message']}');
        
      //   // Unauthorized durumu kontrolü
      //   if (favoritesResult['unauthorized'] == true) {
      //     _handleUnauthorized();
      //     return;
      //   }
      // }

      // // İki listeyi karşılaştır ve isFavorite durumlarını güncelle
      // _updateFavoriteStatus();

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
        _showSnackBar(
          newFavoriteStatus 
            ? '${currentMovie.title} favorilere eklendi!'
            : '${currentMovie.title} favorilerden çıkarıldı!',
          isError: false,
        );

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
    _showSnackBar('Oturumunuz sona erdi. Lütfen tekrar giriş yapın.', isError: true);
    
    // Login sayfasına yönlendir
    Navigator.pushReplacementNamed(context, '/login');
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Filmler yükleniyor...',
                style: TextStyle(color: Colors.white),
              ),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.movie_outlined,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Henüz film bulunmuyor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _refreshMovies,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Yenile'),
              ),
            ],
          ),
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
              return _buildMovieScreen(movie, index);
            },
          ),
          
          // Loading overlay
          if (_isLoadingMovies)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Güncelleniyor...',
                      style: TextStyle(color: Colors.white),
                    ),
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
                  currentIndex: _currentNavIndex,
                  onTap: (index) {
                    setState(() {
                      _currentNavIndex = index;
                    });
          
                    switch (index) {
                      case 0:
                        _showSnackBar('Anasayfa');
                        break;
                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfileView()),
                        );
                        break;
                      default:
                        _showSnackBar('Anasayfa');
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
  }

  Widget _buildMovieScreen(MovieItem movie, int movieIndex) {
     return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image - tam ekran
          CustomNetworkImage(
            imageUrl: movie.posterUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
              child: Image(image: Image.asset( 'assets/IconImage.png').image,
              width: 40,
              height: 40,
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
                  movie.title,
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
                
                const SizedBox(height: 8),
                
                // Film açıklaması
                Text(
                  movie.description,
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
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Kalp butonu - ayrı positioned
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.230,
            right: MediaQuery.of(context).size.width * 0.028,
            child: FavoriteButton(
              isLiked: movie.isFavorite ?? false,
              onTap: () => _toggleFavorite(movie.id, movieIndex),
            ),
          ),
          
          // Pull to refresh indicator (üstte)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _refreshMovies,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Colors.white.withOpacity(0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Yenilemek için tıklayın',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}