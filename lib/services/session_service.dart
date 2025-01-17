import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_any_where_app/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  final String baseUrl = "${ApiConstants.baseApiUrl}/session";

  Future<String> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) {
      throw Exception("Access token is missing");
    }
    return accessToken;
  }

  Future<List<dynamic>> getSessionsByEvent(String eventId) async {
    final accessToken = await _getAccessToken();
    final response = await http.get(
      Uri.parse('$baseUrl/get/$eventId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['sessions'];
    } else {
      throw Exception('Failed to load sessions: ${response.body}');
    }
  }

  Future<bool> createSession({
    required String eventId,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String location,
  }) async {
    final accessToken = await _getAccessToken();
    final response = await http.post(
      Uri.parse('$baseUrl/create/$eventId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "title": title,
        "description": description,
        "start_time": startTime,
        "end_time": endTime,
        "location": location,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to create session: ${response.body}');
    }
  }

  Future<bool> updateSession({
    required String sessionId,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String location,
  }) async {
    final accessToken = await _getAccessToken();
    final response = await http.put(
      Uri.parse('$baseUrl/update/$sessionId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "title": title,
        "description": description,
        "start_time": startTime,
        "end_time": endTime,
        "location": location,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update session: ${response.body}');
    }
  }
}
