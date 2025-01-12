import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'openid', // Yêu cầu OpenID để đảm bảo idToken được trả về
    ],
  );

  Future<Map<String, dynamic>> signInWithGoogle(String platform) async {
    try {
      // Đăng nhập Google
      print("Attempting to sign in with Google...");
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        print("User canceled the login process.");
        throw Exception('User canceled the login process');
      }

      print("Signed in with Google account: ${account.email}");

      // Lấy idToken
      print("Fetching idToken...");
      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) {
        print("Failed to retrieve idToken.");
        throw Exception('Failed to retrieve idToken');
      }

      print("idToken retrieved: $idToken");

      // Gửi idToken và platform tới backend
      print("Sending idToken and platform to backend...");
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/accounts/googleLoginApp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'idToken': idToken,
          'platform': platform,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Login successful. Response data: $data");
        return data; // Trả về thông tin người dùng
      } else {
        print("Login failed. Response body: ${response.body}");
        throw Exception('Login failed: ${response.body}');
      }
    } catch (error, stackTrace) {
      print('Error during Google Sign-In: $error');
      print('StackTrace: $stackTrace');
      rethrow;
    }
  }
}
