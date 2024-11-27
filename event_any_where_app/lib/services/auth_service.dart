import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class AuthService {
  // final String _baseUrl = 'http://10.0.2.2:3000/accounts';
  final String _baseUrl = 'http://192.168.100.12:3000/accounts';

  // Hàm đăng ký
  Future<bool> register(String email, String password, String fullName) async {
    final url = Uri.parse('$_baseUrl/register');
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
            {'name': fullName, 'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data.containsKey('token')) {
          final token = data['token'];
          // await saveTokens(token, '');
          return true;
        } else {
          print('Token not found in registration response');
          return false;
        }
      } else {
        print('Registration failed: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error during registration: $error');
      return false;
    }
  }

  // Hàm đăng nhập
  Future<Map<String, String>?> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(data);

        final accessToken = data['tokenAccess'];
        final refreshToken = data['tokenRefresh'];
        final userInfo = data['user'];

        if (accessToken != null && refreshToken != null && userInfo != null) {
          if (userInfo['hobbies'] is List) {
            userInfo['hobbies'] = (userInfo['hobbies'] as List).join(', ');
          }

          await saveTokens(accessToken, refreshToken);
          await saveUserInfo(userInfo);
          return {
            'access_token': accessToken,
            'refresh_token': refreshToken,
          };
        } else {
          print('Tokens or user info not found in login response');
          return null;
        }
      } else {
        print('Login failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error during login: $error');
      return null;
    }
  }

  // Lưu access token và refresh token vào SharedPreferences
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  // Lưu thông tin người dùng vào SharedPreferences
  Future<void> saveUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userInfo['_id']);
    await prefs.setString('name', userInfo['name'] ?? '');
    await prefs.setString('email', userInfo['email'] ?? '');
    await prefs.setString('role', userInfo['role'] ?? '');
    await prefs.setString('image', userInfo['image'] ?? '');
    await prefs.setString('phone', userInfo['phone'] ?? '');
    await prefs.setString('description', userInfo['description'] ?? '');
    await prefs.setString('address', userInfo['address'] ?? '');
    await prefs.setString('hobbies', userInfo['hobbies'] ?? '');
  }
}
