import 'package:event_any_where_app/core/constants/app_routers.dart';
import 'package:event_any_where_app/models/event_model.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventItem extends StatelessWidget {
  final EventModel eventModel;
  EventItem({
    super.key,
    required this.eventModel,
  });
// Hàm lấy ngày và tháng từ chuỗi "date"
  String getDayAndMonth(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    int day = dateTime.day;
    int month = dateTime.month;
    return "$day \n${_getMonthName(month)}";
  }

  String _getMonthName(int month) {
    const monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push('/event/${eventModel.id}');
      },
      child: Container(
        width: 250,
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 17, 19, 23),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 85, 85, 85).withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Hình ảnh sự kiện
                Container(
                  width: double.infinity,
                  height: 140,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Image(
                    image: eventModel.imageUrl.startsWith('http')
                        ? NetworkImage(eventModel.imageUrl)
                        : AssetImage(eventModel.imageUrl) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),

                // Nhãn "10 Jun"
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 187, 187, 187)
                          .withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      getDayAndMonth(eventModel.date),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 252, 91, 4),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Nút bookmark
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 187, 187, 187)
                          .withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        size: 30,
                        fill: 1,
                        Icons.bookmark_added,
                        color: const Color.fromARGB(255, 252, 91, 4),
                      ),
                      onPressed: () {
                        // Thực hiện hành động khi nhấn nút bookmark
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Text(
                eventModel.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: MyTheme.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 50),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/profile_img1.png"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 26),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/profile_img2.png"),
                      ),
                    ),
                    CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/profile_img3.png"),
                    ),
                  ],
                ),
                SizedBox(width: 8),
                Text(
                  "is attending",
                  style: TextStyle(
                      color: MyTheme.customBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: MyTheme.primaryColor,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        eventModel.location,
                        style: TextStyle(
                            color: const Color.fromARGB(255, 138, 138, 138),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
