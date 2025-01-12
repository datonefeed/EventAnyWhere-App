import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_any_where_app/api/api_constants.dart';
import '../models/event_model.dart';

class FilterService {
  final String _baseUrl = "${ApiConstants.baseApiUrl}/home/filter";

  Future<List<EventModel>> fetchFilteredEvents({
    required String categoryId,
    required String dateOption,
    required String location,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'category_id': categoryId,
      'dateOption': dateOption,
      'location': location,
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['events'] as List;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch events');
    }
  }
}
