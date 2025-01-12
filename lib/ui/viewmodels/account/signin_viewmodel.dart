import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:event_any_where_app/services/auth_service.dart';
import 'package:event_any_where_app/ui/viewmodels/event/event_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:event_any_where_app/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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

    try {
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

        Provider.of<EventViewModel>(context, listen: false).fetchEvents();
        context.go('/entryPoint');
      }
    } catch (error) {
      // `error` here is already the error message string from `AuthService`
      errorMessage = error as String;

      final snackBar = SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Failure!',
          message: 'Login Failed! $errorMessage',
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
