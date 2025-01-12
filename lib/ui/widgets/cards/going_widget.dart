import 'package:flutter/material.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';

class GoingWidget extends StatelessWidget {
  final List<String> speakerImages; // Danh sách URL ảnh của 3 speaker
  final int speakerCount;
  final VoidCallback onQRCodePressed;

  GoingWidget({
    required this.speakerImages,
    required this.speakerCount,
    required this.onQRCodePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: MyTheme.going,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100.0,
            height: 30.0,
            child: Stack(
              children: List.generate(
                speakerImages.length,
                (index) => Positioned(
                  left: index * 20.0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(speakerImages[index]),
                  ),
                ),
              ),
            ),
          ),
          Text(
            '+$speakerCount Going',
            style: TextStyle(
              fontSize: 18,
              color: MyTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: 30,
          ),
          GestureDetector(
            onTap: onQRCodePressed,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MyTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.qr_code,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
