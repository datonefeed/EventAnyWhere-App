import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:event_any_where_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:event_any_where_app/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class SignInViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;
  String errorMessage = '';
  bool rememberMe = false;

  Future<void> login(
      BuildContext context, String email, String password) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    final tokens = await _authService.login(email, password);

    if (tokens != null) {
      if (rememberMe) {
        await _authService.saveTokens(
            tokens['access_token']!, tokens['refresh_token']!);
      }
      final snackBar = SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Success!',
          message: 'Login successfully',
          contentType: ContentType.success,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      context.go('/entryPoint');
    } else {
      errorMessage = 'Invalid email or password';
      final snackBar = SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Failure!',
          message: 'Login Failed! Invalid email or password!',
          contentType: ContentType.failure,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    isLoading = false;
    notifyListeners();
  }

  void toggleRememberMe() {
    rememberMe = !rememberMe;
    notifyListeners();
  }
}
