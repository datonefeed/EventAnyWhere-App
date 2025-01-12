import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_any_where_app/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommendService {
  static const String _baseUrl = "${ApiConstants.baseApiUrl}/api/recommend/";

  Future<List<dynamic>> fetchRecommendations() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null) {
      throw Exception("User ID is not saved in SharedPreferences");
    }

    final response = await http.get(Uri.parse("$_baseUrl$userId"));

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception("Failed to load recommendations: ${response.statusCode}");
    }
  }
}
