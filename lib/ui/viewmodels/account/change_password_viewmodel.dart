import 'package:flutter/material.dart';
import 'package:event_any_where_app/services/auth_service.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    final success = await _authService.changePassword(
        currentPassword, newPassword, confirmPassword);

    if (!success) {
      errorMessage = 'Failed to change password';
    }

    isLoading = false;
    notifyListeners();
  }
}
