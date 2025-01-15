import 'dart:convert';
import 'package:http/http.dart' as http;

class EventSearchService {
  final String baseUrl = 'http://10.0.2.2:3000/home/search';

  Future<List<dynamic>> searchEvents(String keyword) async {
    if (keyword.isEmpty) {
      return [];
    }

    try {
      final uri =
          Uri.parse('$baseUrl?keyword=${Uri.encodeQueryComponent(keyword)}');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('events')) {
          return data['events'] as List<dynamic>;
        } else {
          throw Exception('Invalid response format.');
        }
      } else {
        throw Exception(
          'Failed to fetch events. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }
}
