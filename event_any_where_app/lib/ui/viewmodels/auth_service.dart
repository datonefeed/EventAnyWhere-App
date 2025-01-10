import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:event_any_where_app/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import '';

class AuthService {
  final String _baseUrl = '${ApiConstants.baseApiUrl}/accounts';
  // final String _baseUrl = 'http://192.168.100.12:3000/accounts';

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
          await saveTokens(token, '');
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
          return Future.error(
              'Tokens or user info not found in login response');
        }
      } else {
        final errorData = jsonDecode(response.body);
        final message = errorData['message'] ?? 'An unknown error occurred';
        return Future.error(message);
      }
    } catch (error) {
      print('Error during login: $error');
      return Future.error(error.toString());
    }
  }

  // Phương thức để lấy thông tin hồ sơ người dùng
  Future<Map<String, dynamic>?> getUserProfile() async {
    final url = Uri.parse('$_baseUrl/info');
    final accessToken = await _getAccessToken();

    if (accessToken == null) {
      print("Access token not found");
      return null;
    }

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
      } else {
        print('Failed to load profile: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error loading profile: $error');
      return null;
    }
  }

  // Phương thức để cập nhật hồ sơ người dùng với ảnh
  Future<bool> updateProfileWithImage(
      Map<String, String?> profileData, File? imageFile) async {
    final url = Uri.parse('$_baseUrl/updateProfile');
    final accessToken = await _getAccessToken();
    final userID = await _getUserId();

    if (accessToken == null || userID == null) {
      print("Access token or User ID not found");
      return false;
    }

    // Thêm userID vào profileData
    profileData['_id'] = userID;

    // Tạo request MultipartRequest để gửi file ảnh
    final request = http.MultipartRequest('PUT', url)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..fields
          .addAll(profileData.map((key, value) => MapEntry(key, value ?? '')));

    // Nếu có ảnh, thêm ảnh vào request
    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Profile updated successfully with image');
        return true;
      } else {
        print('Failed to update profile: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error updating profile with image: $error');
      return false;
    }
  }

// Phương thức để cập nhật thông tin hồ sơ người dùng không có ảnh
  Future<bool> updateProfileWithoutImage(
      Map<String, String?> profileData) async {
    final url = Uri.parse('$_baseUrl/updateProfile');
    final accessToken = await _getAccessToken();
    final userID = await _getUserId();
    if (accessToken == null || userID == null) {
      print("Access token or User ID not found");
      return false;
    }

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

      if (response.statusCode == 200) {
        print('Profile updated successfully');
        return true;
      } else {
        print('Failed to update profile: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error updating profile without image: $error');
      return false;
    }
  }

//phương thức thay đổi password
  Future<bool> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    final url = Uri.parse('$_baseUrl/changePassword');
    final accessToken = await _getAccessToken();
    final userId = await _getUserId();

    if (accessToken == null || userId == null) {
      print("Access token or User ID not found");
      return false;
    }

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

      if (response.statusCode == 200) {
        print('Password changed successfully');
        return true;
      } else {
        print('Failed to change password: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error changing password: $error');
      return false;
    }
  }

  // Phương thức để gửi yêu cầu reset mật khẩu
  Future<bool> resetPassword(String email) async {
    final url = Uri.parse('$_baseUrl/reset-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to reset password: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error during reset password: $error');
      return false;
    }
  }

  // Phương thức gửi yêu cầu trở thành organizer
  Future<bool> becomeOrganizer() async {
    final url = Uri.parse('$_baseUrl/organizerRole');
    final accessToken = await _getAccessToken();

    if (accessToken == null) {
      print("Access token not found");
      return false;
    }

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print("Successfully updated to organizer");
        return true;
      } else {
        print('Failed to become organizer: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error during becoming organizer: $error');
      return false;
    }
  }

  // Lấy access token từ SharedPreferences
  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Phương thức để lấy user_id từ SharedPreferences
  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
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
    await prefs.setBool('activeSpeaker', userInfo['activeSpeaker'] ?? '');
  }

  // Xóa access token, refresh token và thông tin người dùng khỏi SharedPreferences
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
