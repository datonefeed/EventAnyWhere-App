import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;
  String errorMessage = '';

  Future<bool> resetPassword(String email) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final success = await _authService.resetPassword(email);
      if (!success) {
        errorMessage = "Failed to send reset password email.";
      }
      return success;
    } catch (error) {
      errorMessage = "An error occurred during the reset password process.";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
