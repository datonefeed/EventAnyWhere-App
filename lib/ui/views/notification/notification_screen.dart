import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:event_any_where_app/ui/viewmodels/notification/notification_viewmodel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationViewModel>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationViewModel>();

    return Scaffold(
      backgroundColor: MyTheme.backgroundcolor,
      appBar: AppBar(
        title: const Text('Notifications'),
        titleTextStyle: AppTextStyles.appbarText,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              size: 25,
              color: MyTheme.white,
            ),
            onPressed: () {
              context.read<NotificationViewModel>().fetchNotifications();
            },
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/ic_not_notification.png'),
                      const SizedBox(height: 16),
                      Text(
                        'No notifications available',
                        style: AppTextStyles.body.copyWith(
                          color: MyTheme.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: viewModel.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = viewModel.notifications[index];
                    return GestureDetector(
                      onLongPress: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor:
                                const Color.fromARGB(255, 10, 10, 11),
                            title: const Text(
                              'Delete Notification',
                              style: AppTextStyles.appbarText,
                            ),
                            content: const Text(
                              'Are you sure you want to delete this notification?',
                              style: AppTextStyles.body,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: MyTheme.primaryColor,
                                      fontSize: 18),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: MyTheme.primaryColor,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete == true) {
                          context
                              .read<NotificationViewModel>()
                              .deleteNotification(notification['_id']);
                        }
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.notification_important,
                          size: 35,
                          color: MyTheme.primaryColor,
                        ),
                        title: Text(
                          notification['title'] ?? 'No Title',
                          style: AppTextStyles.subheading,
                        ),
                        subtitle: Text(
                          notification['message'] ?? 'No Message',
                          style: AppTextStyles.body,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
