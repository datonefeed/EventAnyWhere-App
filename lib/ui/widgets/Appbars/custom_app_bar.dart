import 'package:go_router/go_router.dart';
import 'package:event_any_where_app/core/constants/app_routers.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "           Wellcome to",
                    style: TextStyle(color: MyTheme.white.withOpacity(0.6)),
                  ),
                ],
              ),
              Text(
                "          Event Anywhere",
                style: TextStyle(color: MyTheme.white),
              )
            ],
          ),
        ),
        InkWell(
            onTap: () {
              context.push('/notification');
            },
            child:
                Image(image: AssetImage("assets/icons/ic_notification.png"))),
      ],
    );
  }
}
