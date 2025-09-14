import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jr_case_boilerplate/core/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // API base URL - Gerçek backend URL'nizi buraya yazın
  static const String _baseUrl = 'https://caseapi.servicelabs.tech';
  static const _storage = FlutterSecureStorage();

  // Register
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
          'message': data['message'] ?? 'Kayıt başarılı! E-posta adresinizi doğrulayın.',
          'user': data['user'] != null ? User.fromJson(data['user']) : null,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Kayıt sırasında bir hata oluştu.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Bağlantı hatası: $e',
      };
    }
  }

  // Login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/user/login'),
        headers: {
          'Content-Type': 'application/json',
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
          token: token
        );

        // Token'ı güvenli şekilde sakla
        await _storage.write(key: 'token', value: token);
        await _storage.write(key: 'user', value: jsonEncode(user.toJson()));

        return {
          'success': true,
          'message': 'Giriş başarılı!',
          'user': user,
          'token': token,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Giriş sırasında bir hata oluştu.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Bağlantı hatası: $e',
      };
    }
  }



  // Resend Verification Email
  static Future<Map<String, dynamic>> resendVerificationEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/resend-verification'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Doğrulama e-postası tekrar gönderildi! E-posta kutunuzu kontrol edin.',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'E-posta gönderilemedi.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Bağlantı hatası: $e',
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
}