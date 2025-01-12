import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/constants/app_routers.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import '../../viewmodels/account/profile_viewmodel.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class BecomingOrganizerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: MyTheme.backgroundcolor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Becoming Organizer",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/entryPoint');
          },
        ),
        backgroundColor: MyTheme.backgroundcolor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage("assets/images/event_management.png"),
              height: 350,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final success = await profileViewModel.becomeOrganizer();
                if (success) {
                  final snackBar = SnackBar(
                    content: AwesomeSnackbarContent(
                      title: 'Success',
                      message: 'You are now an organizer!',
                      contentType: ContentType.success,
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  context.go('/entryPoint');
                } else {
                  final snackBar = SnackBar(
                    content: AwesomeSnackbarContent(
                      title: 'Error',
                      message: profileViewModel.errorMessage.isNotEmpty
                          ? profileViewModel.errorMessage
                          : 'Failed to become organizer.',
                      contentType: ContentType.failure,
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                margin: const EdgeInsets.symmetric(horizontal: 76),
                decoration: BoxDecoration(
                  color: MyTheme.primaryColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 30),
                    Expanded(
                      child: const Text(
                        'Becoming Organizer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Image(
                        image: AssetImage('assets/icons/right_arrow.png')),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
