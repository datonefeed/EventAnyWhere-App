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
        throw Exception("No speakers found for this session.");
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized access. Please check your credentials.");
      } else {
        throw Exception("Failed to fetch speakers. Error: ${response.body}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addSpeaker({
    required String sessionId,
    required String email,
    required String position,
  }) async {
    try {
      final accessToken = await _getAccessToken();

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

      if (response.statusCode == 201) {
      } else if (response.statusCode == 400) {
        final errorResponse = json.decode(response.body);
        throw Exception(
          errorResponse['message'] ??
              "Invalid request. Please check the input data.",
        );
      } else if (response.statusCode == 409) {
        throw Exception("Speaker already exists in this session.");
      } else {
        throw Exception("Failed to add speaker. Error: ${response.body}");
      }
    } catch (error) {
      rethrow;
    }
  }
}
