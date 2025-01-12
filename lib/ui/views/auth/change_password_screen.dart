import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:event_any_where_app/ui/views/entry_point.dart';
import '../../viewmodels/account/change_password_viewmodel.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final changePasswordViewModel =
        Provider.of<ChangePasswordViewModel>(context);

    return Scaffold(
      backgroundColor: Color(0xFF1A1F28),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Change Password",
          style: AppTextStyles.appbarText,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordField("Password", currentPasswordController,
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password cannot be empty';
                }
                if (value.length < 7) {
                  return 'Password must be at least 7 characters';
                }
                return null;
              }),
              SizedBox(height: 15),
              _buildPasswordField("New password", newPasswordController,
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'New password cannot be empty';
                }
                if (value.length < 7) {
                  return 'New password must be at least 7 characters';
                }
                return null;
              }),
              SizedBox(height: 15),
              _buildPasswordField("Confirm password", confirmPasswordController,
                  validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirm password cannot be empty';
                }
                if (value != newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              }),
              SizedBox(height: 30),
              changePasswordViewModel.isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await changePasswordViewModel.changePassword(
                            currentPasswordController.text,
                            newPasswordController.text,
                            confirmPasswordController.text,
                          );

                          if (changePasswordViewModel.errorMessage.isEmpty) {
                            final snackBar = SnackBar(
                              content: AwesomeSnackbarContent(
                                title: 'Success!',
                                message: 'Password changed successfully',
                                contentType: ContentType.success,
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            context.pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      changePasswordViewModel.errorMessage)),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyTheme.primaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Save", style: AppTextStyles.subheading),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward,
                            color: MyTheme.white,
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: Colors.white),
      validator: validator,
    );
  }
}
