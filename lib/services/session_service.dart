import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_any_where_app/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  final String baseUrl = "${ApiConstants.baseApiUrl}/session";

//lấy tất cả session đã tạo
  Future<List<dynamic>> getSessionsByEvent(String eventId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      if (accessToken == null) {
        throw Exception("Access token is missing");
      }
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
        throw Exception('Failed to load sessions');
      }
    } catch (error) {
      throw Exception('Error fetching sessions: $error');
    }
  }

// Tạo session
  Future<bool> createSession({
    required String eventId,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String location,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      if (accessToken == null) {
        throw Exception("Access token is missing");
      }

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/session/create/$eventId'),
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
        return true; // Thành công
      } else {
        throw Exception('Failed to create session: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error creating session: $error');
    }
  }

  // Phương thức cập nhật session
  Future<bool> updateSession({
    required String sessionId,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String location,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      if (accessToken == null) {
        throw Exception("Access token is missing");
      }

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
        return true; // Thành công
      } else {
        throw Exception('Failed to update session: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error updating session: $error');
    }
  }
}
