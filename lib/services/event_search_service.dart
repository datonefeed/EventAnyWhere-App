import 'dart:convert';
import 'package:http/http.dart' as http;

class EventSearchService {
  final String baseUrl = 'http://10.0.2.2:3000/home/search';

  Future<List<dynamic>> searchEvents(String keyword) async {
    try {
      // Thêm `keyword` vào query của URL
      final uri = Uri.parse('$baseUrl?keyword=$keyword');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['events'] ?? [];
      } else {
        throw Exception(
            'Failed to fetch events. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }
}
