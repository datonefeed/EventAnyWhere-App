import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/account/profile_viewmodel.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() async {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    await profileViewModel.loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      backgroundColor: Color(0xFF1A1F28),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: MyTheme.backgroundcolor,
                    title: Text(
                      "Confirm Logout",
                      style: AppTextStyles.subheading,
                    ),
                    content: Text(
                      "Are you sure you want to logout?",
                      style: AppTextStyles.body,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: AppTextStyles.body,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          profileViewModel.logout().then((_) {
                            // if (mounted) {
                            context.go('/signin');
                            // }
                          }).catchError((e) {
                            debugPrint('Error during logout: $e');
                          });
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: MyTheme.primaryColor, fontSize: 16),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              "Logout",
              style: TextStyle(
                  color: MyTheme.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: profileViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        profileViewModel.profileImage != null
                            ? FileImage(profileViewModel.profileImage!)
                            : (profileViewModel.profileImageUrl != null
                                    ? NetworkImage(
                                        profileViewModel.profileImageUrl!)
                                    : AssetImage("assets/images/profile.jpg"))
                                as ImageProvider<Object>,
                  ),
                  SizedBox(height: 10),
                  Text(
                    profileViewModel.name ?? '',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    profileViewModel.email ?? '',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(context, "Edit Profile", Icons.edit, () {
                        context.push('/editProfile');
                      }),
                      SizedBox(width: 10),
                      _buildButton(context, "Change Password", Icons.lock, () {
                        context.push('/changePassword');
                      }),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildSectionTitle("About Me"),
                  Text(
                    profileViewModel.description ?? 'No description available.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  _buildSectionTitle("Hobbies"),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _buildHobbies(profileViewModel.hobbies),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon,
      VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: MyTheme.primaryColor),
      label: Text(
        text,
        style: TextStyle(color: MyTheme.primaryColor),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: MyTheme.primaryColor),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  List<Widget> _buildHobbies(String? hobbies) {
    if (hobbies == null || hobbies.isEmpty) return [];
    final List<String> hobbiesList = hobbies.split(', ');
    return hobbiesList.map((hobby) {
      final color = _generateRandomColor();
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          hobby,
          style: TextStyle(color: Colors.white),
        ),
      );
    }).toList();
  }

  Color _generateRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
