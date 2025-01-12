import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_any_where_app/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final String _endpoint = '${ApiConstants.baseApiUrl}/notification/get';
  final String _baseEndpoint = '${ApiConstants.baseApiUrl}/notification';

  Future<List<Map<String, dynamic>>?> fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final accessToken = prefs.getString('access_token');

    if (userId == null || accessToken == null) {
      print('User ID or Access Token not found.');
      return null;
    }

    final url = Uri.parse('$_endpoint/$userId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['notifications']);
      } else {
        print('Failed to fetch notifications: ${response.body}');
        return null;
      }
    } catch (error) {
      print('Error fetching notifications: $error');
      return null;
    }
  }

  Future<bool> deleteNotification(String notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      print('Access Token not found.');
      return false;
    }

    final url = Uri.parse('$_baseEndpoint/delete/$notificationId');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Notification deleted successfully');
        return true;
      } else {
        print('Failed to delete notification: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error deleting notification: $error');
      return false;
    }
  }
}
