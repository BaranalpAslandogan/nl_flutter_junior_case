import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jr_case_boilerplate/core/models/user_model.dart';

class AuthService {
  // API base URL
  static const String _baseUrl = 'https://caseapi.servicelabs.tech';
  static const _storage = FlutterSecureStorage();

  // Register - POST /user/register
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/user/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Kayıt başarılı! Şimdi giriş yapabilirsiniz.',
          'user': data['user'] != null ? User.fromJson(data['user']) : null,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? data['error'] ?? 'Kayıt sırasında bir hata oluştu.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Bağlantı hatası: ${e.toString()}',
      };
    }
  }

  // Login - POST /user/login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/user/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data["data"]['token'];
        final user = User(
          id: data["data"]['_id'],
          email: data["data"]['email'],
          name: data["data"]['name'],
          token: token,
        );

        // Token'ı güvenli şekilde sakla
        await _storage.write(key: 'token', value: token);
        await _storage.write(key: 'user', value: jsonEncode(user.toJson()));

        return {
          'success': true,
          'message': data['message'] ?? 'Giriş başarılı!',
          'user': user,
          'token': token,
        };
      } else {
        return {
          'success': false,
          'message': data['response']?['message'] ?? data['message'] ?? data['error'] ?? 'Giriş sırasında bir hata oluştu.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Bağlantı hatası: ${e.toString()}',
      };
    }
  }

  // Get Profile - GET /user/profile (Token gerekli)
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Token bulunamadı. Lütfen tekrar giriş yapın.',
        };
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final userData = data['data'];
        final user = User(
          id: userData['_id'],
          email: userData['email'],
          name: userData['name'],
          token: userData['token'],
          photoUrl: userData['photoUrl'],
        );
        
        // Kullanıcı bilgilerini güncelle
        await _storage.write(key: 'user', value: jsonEncode(user.toJson()));

        return {
          'success': true,
          'message': 'Profil bilgileri alındı.',
          'user': user,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? data['error'] ?? 'Profil bilgileri alınamadı.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Bağlantı hatası: ${e.toString()}',
      };
    }
  }

  // Upload Photo - POST /user/upload_photo (Token gerekli)
  static Future<Map<String, dynamic>> uploadPhoto({
    required File photoFile,
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Token bulunamadı. Lütfen tekrar giriş yapın.',
        };
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/user/upload_photo'),
      );

      // Headers ekle
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Dosyayı ekle
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // API'de beklenen field adı
          photoFile.path,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Fotoğraf başarıyla yüklendi!',
          'photoUrl': data['photoUrl'] ?? data['data']?['photoUrl'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? data['error'] ?? 'Fotoğraf yüklenemedi.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Bağlantı hatası: ${e.toString()}',
      };
    }
  }

  // Get Current User
  static Future<User?> getCurrentUser() async {
    try {
      final userJson = await _storage.read(key: 'user');
      if (userJson != null) {
        return User.fromJson(jsonDecode(userJson));
      }
    } catch (e) {
      print('Kullanıcı bilgisi alınamadı: $e');
    }
    return null;
  }

  // Get Token
  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'token');
    } catch (e) {
      print('Token alınamadı: $e');
    }
    return null;
  }

  // Logout
  static Future<void> logout() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'user');
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Make authenticated request headers
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Refresh Profile - Profil bilgilerini backend'den yenile
  static Future<Map<String, dynamic>> refreshProfile() async {
    try {
      final profileResult = await getProfile();
      if (profileResult['success']) {
        return {
          'success': true,
          'message': 'Profil bilgileri güncellendi.',
          'user': profileResult['user'],
        };
      } else {
        return profileResult;
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Profil yenilenemedi: ${e.toString()}',
      };
    }
  }
}