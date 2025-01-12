import 'package:flutter/material.dart';
import 'package:event_any_where_app/models/session_model.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventSessionTab extends StatelessWidget {
  final List<Session> sessions;

  EventSessionTab({required this.sessions});

  String formatEventTime(String date) {
    // Chuyển đổi date thành đối tượng DateTime
    DateTime dateTime = DateTime.parse(date);

    // Định dạng giờ và phút cùng với AM/PM
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                context.push(
                  '/sessionDetail',
                  extra: session,
                );
              },
              child: ListTile(
                title: Text(session.title, style: AppTextStyles.appbarText),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.access_time,
                          color: MyTheme.primaryColor,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                            '${formatEventTime(session.startTime)} - ${formatEventTime(session.endTime)}',
                            style: AppTextStyles.body),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: MyTheme.primaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(session.location, style: AppTextStyles.body),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: session.sessionSpeakers.map((speaker) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(speaker.profileImageUrl),
                    ),
                    title: Text(speaker.name, style: AppTextStyles.body),
                    subtitle: Text(speaker.position, style: AppTextStyles.body),
                  );
                }).toList(),
              ),
            ),
            Divider(
              color: const Color.fromARGB(255, 210, 132, 84),
              indent: 12,
              endIndent: 12,
            ),
          ],
        );
      },
    );
  }
}
