import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:event_any_where_app/services/auth_service.dart';
import 'package:event_any_where_app/ui/viewmodels/event/event_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignInViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;
  String errorMessage = '';
  bool rememberMe = false;

  Future<void> login(
      BuildContext context, String email, String password) async {
    _setLoadingState(true);
    errorMessage = '';

    try {
      final tokens = await _authService.login(email, password);
      if (tokens != null) {
        await _handleLoginSuccess(context, tokens);
      }
    } catch (error) {
      errorMessage = error.toString();
      _showSnackBar(context, 'Failure!', 'Login Failed! $errorMessage',
          ContentType.failure);
    } finally {
      _setLoadingState(false);
    }
  }

  void toggleRememberMe() {
    rememberMe = !rememberMe;
    notifyListeners();
  }

  void _setLoadingState(bool state) {
    isLoading = state;
    notifyListeners();
  }

  Future<void> _handleLoginSuccess(
      BuildContext context, Map<String, String> tokens) async {
    if (rememberMe) {
      await _authService.saveTokens(
          tokens['access_token']!, tokens['refresh_token']!);
    }

    _showSnackBar(
        context, 'Success!', 'Login successfully', ContentType.success);
    Provider.of<EventViewModel>(context, listen: false).fetchEvents();
    context.go('/entryPoint');
  }

  void _showSnackBar(
      BuildContext context, String title, String message, ContentType type) {
    final snackBar = SnackBar(
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
