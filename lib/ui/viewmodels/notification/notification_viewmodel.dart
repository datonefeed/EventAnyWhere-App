import 'package:flutter/material.dart';
import 'package:event_any_where_app/services/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    final data = await _service.fetchNotifications();
    if (data != null) {
      _notifications = data;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteNotification(String notificationId) async {
    final success = await _service.deleteNotification(notificationId);
    if (success) {
      _notifications
          .removeWhere((notification) => notification['_id'] == notificationId);
      notifyListeners();
    }
  }
}
