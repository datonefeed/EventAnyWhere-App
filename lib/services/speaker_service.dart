import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_any_where_app/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpeakerService {
  final String baseUrl = "${ApiConstants.baseApiUrl}/speaker";

  Future<String> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) {
      throw Exception("Access token is missing. Please log in again.");
    }
    return accessToken;
  }

  Future<List<dynamic>> getSpeakersBySession(String sessionId) async {
    try {
      final accessToken = await _getAccessToken();
      final url = Uri.parse('$baseUrl/$sessionId');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['sessionSpeakers'];
      } else if (response.statusCode == 404) {
        throw Exception("No speakers found for session ID: $sessionId");
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? "Failed to fetch speakers");
      }
    } catch (error) {
      throw Exception('Error fetching speakers: $error');
    }
  }

  Future<void> addSpeaker(
      String sessionId, String email, String position) async {
    try {
      final accessToken = await _getAccessToken();
      final url = Uri.parse('$baseUrl/add');

      final response = await http.post(
        url,
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
