import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MovieService {
  // API base URL
  static const String _baseUrl = 'https://caseapi.servicelabs.tech';
  static const _storage = FlutterSecureStorage();

  // Get Token
  static Future<String?> _getToken() async {
    try {
      return await _storage.read(key: 'token');
    } catch (e) {
      print('Token alınamadı: $e');
    }
    return null;
  }

  // Get authenticated headers
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Get Movie List - GET /movie/list
  static Future<Map<String, dynamic>> getMovieList({int page = 1}) async {
    try {
      final headers = await _getAuthHeaders();
      
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/list?page=$page'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Film listesi başarıyla alındı.',
          'data': data['data'],
          'movies': data['data']['movies'] ?? [],
          'totalPages': data['data']['pagination']['maxPage'] ?? 0,
          'currentPage': data['data']['pagination']['currentPage'] ?? 1,
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Yetkisiz erişim. Lütfen tekrar giriş yapın.',
          'unauthorized': true,
        };
      } else {
        return {
          'success': false,
          'message': data['response']['message'] ?? 'Film listesi alınamadı.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Bağlantı hatası: ${e.toString()}',
      };
    }
  }

  // Get Favorite Movies - GET /movie/favorites (Token gerekli)
  static Future<Map<String, dynamic>> getFavoriteMovies() async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Token bulunamadı. Lütfen tekrar giriş yapın.',
          'unauthorized': true,
        };
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/movie/favorites'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Favori filmler başarıyla alındı.',
          'data': data['data'],
          'movies': data['data'] ?? [],
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Yetkisiz erişim. Lütfen tekrar giriş yapın.',
          'unauthorized': true,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? data['error'] ?? 'Favori filmler alınamadı.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Bağlantı hatası: ${e.toString()}',
      };
    }
  }

  // Toggle Favorite Movie - POST /movie/favorite/{favoriteId} (Token gerekli)
  static Future<Map<String, dynamic>> toggleFavorite({
    required String favoriteId,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Token bulunamadı. Lütfen tekrar giriş yapın.',
          'unauthorized': true,
        };
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/movie/favorite/$favoriteId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Favori durumu başarıyla değiştirildi.',
          'data': data,
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Yetkisiz erişim. Lütfen tekrar giriş yapın.',
          'unauthorized': true,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? data['error'] ?? 'Favori durumu değiştirilemedi.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Bağlantı hatası: ${e.toString()}',
      };
    }
  }

  // Add to Favorites - Film ID ile favori ekleme (helper method)
  static Future<Map<String, dynamic>> addToFavorites({
    required String movieId,
  }) async {
    return await toggleFavorite(favoriteId: movieId);
  }

  // Remove from Favorites - Film ID ile favoriden çıkarma (helper method)
  static Future<Map<String, dynamic>> removeFromFavorites({
    required String movieId,
  }) async {
    return await toggleFavorite(favoriteId: movieId);
  }

  // Check if movie is favorite - Filmin favori olup olmadığını kontrol et
  static Future<bool> isMovieFavorite({
    required String movieId,
  }) async {
    try {
      final favoritesResult = await getFavoriteMovies();
      if (favoritesResult['success']) {
        final favoriteMovies = favoritesResult['movies'] as List;
        return favoriteMovies.any((movie) => movie['id'].toString() == movieId);
      }
      return false;
    } catch (e) {
      print('Favori kontrolü yapılamadı: $e');
      return false;
    }
  }

  // Get Movie List with Favorite Status - Film listesi + favori durumu
  static Future<Map<String, dynamic>> getMovieListWithFavorites({
    int page = 1,
  }) async {
    try {
      // Önce film listesini al
      final moviesResult = await getMovieList(page: page);
      if (!moviesResult['success']) {
        return moviesResult;
      }

      // Sonra favori filmleri al
      final favoritesResult = await getFavoriteMovies();
      final favoriteMovieIds = <String>[];
      
      if (favoritesResult['success']) {
        final favoriteMovies = favoritesResult['movies'] as List;
        favoriteMovieIds.addAll(
          favoriteMovies.map((movie) => movie['id'].toString()),
        );
      }

      // Film listesine favori durumunu ekle
      final movies = moviesResult['movies'] as List;
      final moviesWithFavorites = movies.map((movie) {
        return {
          ...movie,
          'isFavorite': favoriteMovieIds.contains(movie['id'].toString()),
        };
      }).toList();

      return {
        ...moviesResult,
        'movies': moviesWithFavorites,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Film listesi alınamadı: ${e.toString()}',
      };
    }
  }

  // Refresh Movies - Film listesini yenile
  static Future<Map<String, dynamic>> refreshMovies({int page = 1}) async {
    return await getMovieListWithFavorites(page: page);
  }
}