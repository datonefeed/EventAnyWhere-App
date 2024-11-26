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
}
