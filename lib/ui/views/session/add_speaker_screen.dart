import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:event_any_where_app/ui/viewmodels/event/speaker_viewmodel.dart';

class AddSpeakerScreen extends StatelessWidget {
  final String sessionId;

  AddSpeakerScreen({required this.sessionId});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final speakerViewModel = Provider.of<SpeakerViewModel>(context);

    return Scaffold(
      backgroundColor: MyTheme.backgroundcolor,
      appBar: AppBar(
        backgroundColor: MyTheme.backgroundcolor,
        title: Text('Add Speaker'),
        titleTextStyle: AppTextStyles.appbarText,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                focusColor: MyTheme.primaryColor,
                hintText: "Enter speaker email",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: MyTheme.backgroundcolor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              "Position",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: positionController,
              decoration: InputDecoration(
                focusColor: MyTheme.primaryColor,
                hintText: "Enter speaker position",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: MyTheme.backgroundcolor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 50),
            speakerViewModel.isLoading
                ? CircularProgressIndicator()
                : GestureDetector(
                    onTap: () async {
                      final email = emailController.text.trim();
                      final position = positionController.text.trim();

                      if (email.isEmpty || position.isEmpty) {
                        final snackBar = SnackBar(
                          content: AwesomeSnackbarContent(
                            title: 'Warning!',
                            message: 'Please fill on the Field!',
                            contentType: ContentType.warning,
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      }

                      await speakerViewModel.addSpeaker(
                          sessionId, email, position);

                      if (speakerViewModel.errorMessage != null) {
                        final snackBar = SnackBar(
                          content: AwesomeSnackbarContent(
                            title: 'Failure!',
                            message: speakerViewModel.errorMessage!,
                            contentType: ContentType.failure,
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        final snackBar = SnackBar(
                          content: AwesomeSnackbarContent(
                            title: 'Success!',
                            message: 'Add Speaker successfully!',
                            contentType: ContentType.success,
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        context.pop();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      margin: const EdgeInsets.symmetric(horizontal: 46),
                      decoration: BoxDecoration(
                        color: MyTheme.primaryColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 30),
                          Expanded(
                            child: Text(
                              'Add Speaker',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: MyTheme.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Image(
                              image:
                                  AssetImage('assets/icons/right_arrow.png')),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
