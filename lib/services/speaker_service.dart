import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_any_where_app/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpeakerService {
  final String baseUrl = "${ApiConstants.baseApiUrl}/speaker";

  Future<List<dynamic>> getSpeakersBySession(String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      if (accessToken == null) {
        throw Exception("Access token is missing");
      }

      final response = await http.get(
        Uri.parse('$baseUrl/$sessionId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['sessionSpeakers'];
      } else if (response.statusCode == 404) {
        throw Exception("No speakers found for this session");
      } else {
        throw Exception("Failed to fetch speakers");
      }
    } catch (error) {
      throw Exception('Error fetching speakers: $error');
    }
  }

  // Phương pháp thêm speaker
  Future<void> addSpeaker(
      String sessionId, String email, String position) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      if (accessToken == null) {
        throw Exception("Access token is missing");
      }

      final response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'session_id': sessionId,
          'email': email,
          'position': position,
        }),
      );

      if (response.statusCode != 201) {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? "Failed to add speaker");
      }
    } catch (error) {
      throw Exception('Error adding speaker: $error');
    }
  }
}
