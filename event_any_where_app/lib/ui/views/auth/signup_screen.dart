import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import '../../viewmodels/signup_viewmodel.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SignUpViewModel>(
        builder: (context, viewModel, child) {
          return LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: viewportConstraints.maxHeight),
                  child: Container(
                    width: double.infinity,
                    color: Color(0xFF1A1F28),
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                context.go('/signin');
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: MyTheme.white,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            SizedBox(width: 22),
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                color: MyTheme.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        _buildTextField(
                          controller: _nameController,
                          hintText: 'Full name',
                          prefixIcon: 'assets/icons/Profile.png',
                        ),
                        SizedBox(height: 20),
                        _buildTextField(
                          controller: _emailController,
                          hintText: 'abc@gmail.com',
                          prefixIcon: 'assets/icons/Mail.png',
                        ),
                        SizedBox(height: 20),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: 'Your password',
                          prefixIcon: 'assets/icons/Password.png',
                          isPassword: true,
                        ),
                        SizedBox(height: 20),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          hintText: 'Confirm password',
                          prefixIcon: 'assets/icons/Password.png',
                          isPassword: true,
                        ),
                        SizedBox(height: 36),
                        viewModel.isLoading
                            ? CircularProgressIndicator()
                            : GestureDetector(
                                onTap: () {
                                  viewModel.register(
                                    context,
                                    _nameController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                    _confirmPasswordController.text,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  margin: EdgeInsets.symmetric(horizontal: 46),
                                  decoration: BoxDecoration(
                                    color: MyTheme.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 30),
                                      Expanded(
                                        child: Text(
                                          'SIGN UP',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: MyTheme.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Image(
                                          image: AssetImage(
                                              'assets/icons/right_arrow.png')),
                                      SizedBox(width: 12),
                                    ],
                                  ),
                                ),
                              ),
                        if (viewModel.errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              viewModel.errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        SizedBox(height: 20),
                        Text(
                          'OR',
                          style: TextStyle(color: MyTheme.grey, fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        _buildSocialLoginButton(
                          iconPath: 'assets/icons/google.png',
                          text: 'Login with Google',
                        ),
                        SizedBox(height: 12),
                        _buildSocialLoginButton(
                          iconPath: 'assets/icons/facebook.png',
                          text: 'Login with Facebook',
                        ),
                        SizedBox(height: 26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style:
                                  TextStyle(color: MyTheme.white, fontSize: 16),
                            ),
                            SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                context.go('/signin');
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                    color: MyTheme.primaryColor, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String prefixIcon,
    bool isPassword = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22),
      child: TextField(
        style: TextStyle(color: MyTheme.white, fontSize: 16),
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Image(image: AssetImage(prefixIcon)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: MyTheme.grey),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton(
      {required String iconPath, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      margin: EdgeInsets.symmetric(horizontal: 46),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        children: [
          SizedBox(width: 46),
          Image(image: AssetImage(iconPath)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.black, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 46),
        ],
      ),
    );
  }
}
