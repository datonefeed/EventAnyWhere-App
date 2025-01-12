import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_any_where_app/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventParticipationService {
  final String _baseUrl = '${ApiConstants.baseApiUrl}';

  Future<bool> joinEvent(String eventId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final token = prefs.getString('access_token');

    if (userId == null || token == null) {
      throw Exception('User is not authenticated');
    }

    print("Sending joinEvent request: eventId=$eventId, userId=$userId");

    final response = await http.post(
      Uri.parse('$_baseUrl/participation/join'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'userId': userId, 'eventId': eventId}),
    );

    print("joinEvent response status: ${response.statusCode}");
    print("joinEvent response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['hasJoin'];
    } else {
      throw Exception('Failed to join event: ${response.statusCode}');
    }
  }

  Future<bool> checkJoinStatus(String eventId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final token = prefs.getString('access_token');

    if (userId == null || token == null) {
      throw Exception('User is not authenticated');
    }

    print("Sending checkJoinStatus request: eventId=$eventId, userId=$userId");

    final response = await http.post(
      Uri.parse('$_baseUrl/participation/checkJoin'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'userId': userId, 'eventId': eventId}),
    );

    print("checkJoinStatus response status: ${response.statusCode}");
    print("checkJoinStatus response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['hasJoin'];
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception('Failed to check join status: ${response.statusCode}');
    }
  }
}
