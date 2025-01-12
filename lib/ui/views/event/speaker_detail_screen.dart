import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:event_any_where_app/models/speaker_model.dart';

class SpeakerDetailScreen extends StatelessWidget {
  final Speaker speaker;

  const SpeakerDetailScreen({Key? key, required this.speaker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.backgroundcolor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'Speaker Detail',
          style: AppTextStyles.appbarText,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(speaker.profileImageUrl),
              ),
              const SizedBox(height: 16),
              Text(speaker.name, style: AppTextStyles.heading),
              const SizedBox(height: 8),
              Text(
                speaker.position,
                style: const TextStyle(
                    fontSize: 28,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                speaker.bio,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
