import 'package:flutter/material.dart';
import 'package:event_any_where_app/models/event_detail_model.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:event_any_where_app/ui/widgets/cards/going_widget.dart';
import 'package:intl/intl.dart';

class EventOverviewTab extends StatelessWidget {
  final EventDetail event;

  EventOverviewTab({required this.event});

  String formatDateTime(String inputDateTime) {
    try {
      // Parse chuỗi ISO 8601 thành đối tượng DateTime
      DateTime dateTime = DateTime.parse(inputDateTime);

      // Định dạng lại thời gian thành "9:00 PM, 15 Nov 2024"
      String formattedDateTime =
          DateFormat('h:mm a, dd MMM yyyy').format(dateTime);

      return formattedDateTime;
    } catch (e) {
      // Xử lý lỗi nếu đầu vào không hợp lệ
      return "Invalid Date Format";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: Image.network(
                    event.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 218,
                  child: Center(
                    child: GoingWidget(
                      speakerImages: event.speakers
                          .take(3)
                          .map((speaker) => speaker.profileImageUrl)
                          .toList(),
                      speakerCount: event.speakers.length,
                      onQRCodePressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Event QR Code',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  width: 200,
                                  height: 200,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: Icon(
                                      Icons.qr_code,
                                      size: 100,
                                      color: MyTheme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    event.title,
                    style: AppTextStyles.heading,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Image(image: AssetImage('assets/icons/ic_date.png')),
                      SizedBox(width: 8),
                      Text(formatDateTime(event.date),
                          style: AppTextStyles.description),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Image(image: AssetImage('assets/icons/ic_location.png')),
                      SizedBox(width: 8),
                      Text(event.location, style: AppTextStyles.description),
                    ],
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(event.organizer.image),
                    ),
                    title: Text(event.organizer.name,
                        style: AppTextStyles.subheading),
                    subtitle: Text('Organizer', style: AppTextStyles.body),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'About Event',
                    style: AppTextStyles.subheading,
                  ),
                  SizedBox(height: 8),
                  Text(event.description, style: AppTextStyles.body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
