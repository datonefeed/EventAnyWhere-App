import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
  );

  Future<Map<String, dynamic>> signInWithGoogle(String platform) async {
    final account = await _googleSignIn.signIn();
    if (account == null) throw Exception('Login process canceled by user');

    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null) throw Exception('Failed to retrieve idToken');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/accounts/googleLoginApp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken, 'platform': platform}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }
}
