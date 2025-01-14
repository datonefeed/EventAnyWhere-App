import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:event_any_where_app/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class AuthService {
  final String _baseUrl = '${ApiConstants.baseApiUrl}/accounts';

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
          await saveTokens(token, '');
          return true;
        }
        return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

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
        }
        return Future.error('Tokens or user info not found in login response');
      }

      final errorData = jsonDecode(response.body);
      final message = errorData['message'] ?? 'An unknown error occurred';
      return Future.error(message);
    } catch (error) {
      return Future.error(error.toString());
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final url = Uri.parse('$_baseUrl/info');
    final accessToken = await _getAccessToken();

    if (accessToken == null) return null;

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateProfileWithImage(
      Map<String, String?> profileData, File? imageFile) async {
    final url = Uri.parse('$_baseUrl/updateProfile');
    final accessToken = await _getAccessToken();
    final userID = await _getUserId();

    if (accessToken == null || userID == null) return false;

    profileData['_id'] = userID;

    final request = http.MultipartRequest('PUT', url)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..fields
          .addAll(profileData.map((key, value) => MapEntry(key, value ?? '')));

    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    try {
      final response = await request.send();
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateProfileWithoutImage(
      Map<String, String?> profileData) async {
    final url = Uri.parse('$_baseUrl/updateProfile');
    final accessToken = await _getAccessToken();
    final userID = await _getUserId();

    if (accessToken == null || userID == null) return false;

    profileData['_id'] = userID;

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(profileData),
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    final url = Uri.parse('$_baseUrl/changePassword');
    final accessToken = await _getAccessToken();
    final userId = await _getUserId();

    if (accessToken == null || userId == null) return false;

    final requestData = {
      '_id': userId,
      'password': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    final url = Uri.parse('$_baseUrl/reset-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> becomeOrganizer() async {
    final url = Uri.parse('$_baseUrl/organizerRole');
    final accessToken = await _getAccessToken();

    if (accessToken == null) return false;

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

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
    await prefs.setBool('activeSpeaker', userInfo['activeSpeaker'] ?? false);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_id');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('role');
    await prefs.remove('image');
    await prefs.remove('phone');
    await prefs.remove('description');
    await prefs.remove('address');
    await prefs.remove('hobbies');
    await prefs.remove('activeSpeaker');
  }
}
