import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import '../../viewmodels/account/reset_password_viewmodel.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool isTimerActive = false;
  int resendTimer = 20;

  @override
  Widget build(BuildContext context) {
    final resetPasswordViewModel = Provider.of<ResetPasswordViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1F28),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Reset Password",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/signin');
          },
        ),
      ),
      body: resetPasswordViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Please enter your email address to request a password reset",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF2A2F38),
                      prefixIcon: const Icon(Icons.email, color: Colors.grey),
                      hintText: "abc@email.com",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: isTimerActive
                        ? null
                        : () async {
                            final email = _emailController.text.trim();
                            if (email.isEmpty) {
                              showSnackbar(
                                context,
                                "Error",
                                "Email cannot be empty",
                                ContentType.failure,
                              );
                              return;
                            }

                            final success = await resetPasswordViewModel
                                .resetPassword(email);

                            if (success) {
                              showSnackbar(
                                context,
                                "Success",
                                "A reset password email has been sent.",
                                ContentType.success,
                              );
                              startResendTimer();
                            } else {
                              showSnackbar(
                                context,
                                "Error",
                                resetPasswordViewModel.errorMessage.isNotEmpty
                                    ? resetPasswordViewModel.errorMessage
                                    : "Failed to send reset password email.",
                                ContentType.failure,
                              );
                            }
                          },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      margin: const EdgeInsets.symmetric(horizontal: 76),
                      decoration: BoxDecoration(
                        color:
                            isTimerActive ? Colors.grey : MyTheme.primaryColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 30),
                          Expanded(
                            child: Text(
                              'SEND',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isTimerActive
                                    ? Colors.white70
                                    : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Image(
                            image: AssetImage('assets/icons/right_arrow.png'),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isTimerActive)
                    Text(
                      "Re-send code in 0:$resendTimer",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  void startResendTimer() {
    setState(() {
      isTimerActive = true;
      resendTimer = 20;
    });
    Future.delayed(const Duration(seconds: 20), () {
      setState(() {
        isTimerActive = false;
      });
    });
    for (int i = 1; i <= 20; i++) {
      Future.delayed(Duration(seconds: i), () {
        setState(() {
          resendTimer = 20 - i;
        });
      });
    }
  }

  void showSnackbar(BuildContext context, String title, String message,
      ContentType contentType) {
    final snackBar = SnackBar(
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
