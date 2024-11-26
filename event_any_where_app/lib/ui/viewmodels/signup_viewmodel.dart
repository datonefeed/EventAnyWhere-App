import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:event_any_where_app/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class SignUpViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> register(BuildContext context, String fullName, String email,
      String password, String confirmPassword) async {
    errorMessage = '';
    if (fullName.isEmpty) {
      final snackBar = SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Failed!',
          message: 'Register Failed! Name is empty!',
          contentType: ContentType.failure,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      errorMessage = 'Name is empty!';
    } else if (email.isEmpty ||
        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      final snackBar = SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Failed!',
          message: 'Register Failed! Please enter a valid email!',
          contentType: ContentType.failure,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      errorMessage = 'Please enter a valid email!';
    } else if (password.isEmpty || password.length < 6) {
      final snackBar = SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Failed!',
          message: 'Register Failed! Password must be at least 6 characters!',
          contentType: ContentType.failure,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      errorMessage = 'Password must be at least 6 characters!';
    } else if (confirmPassword != password) {
      final snackBar = SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Failed!',
          message: 'Register Failed! Confirmation password does not match!',
          contentType: ContentType.failure,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      errorMessage = 'Confirmation password does not match!';
    }

    if (errorMessage.isNotEmpty) {
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    final success = await _authService.register(email, password, fullName);
    isLoading = false;

    if (success) {
      final snackBar = SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Success!',
          message: 'Register successfully! Please log in!',
          contentType: ContentType.success,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      context.go('/signin');
    } else {
      final snackBar = SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Failure!',
          message: 'Register failed! Registration failed, please try again!',
          contentType: ContentType.failure,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      errorMessage = 'Registration failed, please try again!';
    }

    notifyListeners();
  }
}
