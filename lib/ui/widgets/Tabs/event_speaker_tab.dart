import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:event_any_where_app/models/speaker_model.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';

class EventSpeakerTab extends StatelessWidget {
  final List<Speaker> speakers;

  EventSpeakerTab({required this.speakers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: speakers.length,
      itemBuilder: (context, index) {
        final speaker = speakers[index];
        return InkWell(
          onTap: () {
            context.push(
              '/speakerDetail',
              extra: speaker,
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(speaker.profileImageUrl),
            ),
            title: Text(speaker.name, style: AppTextStyles.subheading),
            subtitle: Text(speaker.position, style: AppTextStyles.body),
          ),
        );
      },
    );
  }
}
