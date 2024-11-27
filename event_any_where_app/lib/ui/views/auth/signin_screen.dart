import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/my_theme.dart';
import '../../viewmodels/signin_viewmodel.dart';
import 'package:go_router/go_router.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SignInViewModel>(
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
                    color: const Color(0xFF1A1F28),
                    child: Column(
                      children: [
                        const SizedBox(height: 84),
                        const Image(
                            image: AssetImage('assets/images/logo.png')),
                        const SizedBox(height: 5),
                        const Text(
                          'EventAnywhere',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 45),
                        Row(
                          children: [
                            const SizedBox(width: 22),
                            Text(
                              'Sign In',
                              style: TextStyle(
                                color: MyTheme.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _emailController,
                          hintText: 'abc@gmail.com',
                          prefixIcon: 'assets/icons/Mail.png',
                          isPassword: false,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: 'Your password',
                          prefixIcon: 'assets/icons/Password.png',
                          isPassword: true,
                          onSuffixTap: () {
                            setState(() {
                              _isPasswordHidden = !_isPasswordHidden;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildRememberMeAndForgotPassword(viewModel),
                        const SizedBox(height: 16),
                        viewModel.isLoading
                            ? const CircularProgressIndicator()
                            : GestureDetector(
                                onTap: () => viewModel.login(
                                  context,
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 46),
                                  decoration: BoxDecoration(
                                    color: MyTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 30),
                                      Expanded(
                                        child: Text(
                                          'SIGN IN',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: MyTheme.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Image(
                                          image: AssetImage(
                                              'assets/icons/right_arrow.png')),
                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                ),
                              ),
                        if (viewModel.errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              viewModel.errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Text(
                          'OR',
                          style: TextStyle(color: MyTheme.grey, fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        _buildSocialLoginButton(
                          iconPath: 'assets/icons/google.png',
                          text: 'Login with Google',
                        ),
                        const SizedBox(height: 12),
                        _buildSocialLoginButton(
                          iconPath: 'assets/icons/facebook.png',
                          text: 'Login with Facebook',
                        ),
                        const SizedBox(height: 26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style:
                                  TextStyle(color: MyTheme.white, fontSize: 16),
                            ),
                            const SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                context.go('/signup');
                              },
                              child: Text(
                                "Sign up",
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
    VoidCallback? onSuffixTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      child: TextField(
        style: TextStyle(color: MyTheme.white, fontSize: 16),
        controller: controller,
        obscureText: isPassword && _isPasswordHidden,
        decoration: InputDecoration(
          prefixIcon: Image(image: AssetImage(prefixIcon)),
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: onSuffixTap,
                  child: Icon(
                    _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                    color: MyTheme.grey,
                  ),
                )
              : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: MyTheme.grey),
        ),
      ),
    );
  }

  Widget _buildRememberMeAndForgotPassword(SignInViewModel viewModel) {
    return Row(
      children: [
        const SizedBox(width: 22),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: viewModel.rememberMe,
            onChanged: (value) {
              viewModel.toggleRememberMe();
            },
            activeColor: MyTheme.white,
            activeTrackColor: MyTheme.primaryColor,
          ),
        ),
        Text(
          'Remember Me',
          style: TextStyle(color: MyTheme.white, fontSize: 16),
        ),
        Expanded(
          child: Text(
            'Forgot Password?',
            textAlign: TextAlign.right,
            style: TextStyle(color: MyTheme.white, fontSize: 16),
          ),
        ),
        const SizedBox(width: 22),
      ],
    );
  }

  Widget _buildSocialLoginButton({
    required String iconPath,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      margin: const EdgeInsets.symmetric(horizontal: 46),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const SizedBox(width: 46),
          Image(image: AssetImage(iconPath)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 46),
        ],
      ),
    );
  }
}
