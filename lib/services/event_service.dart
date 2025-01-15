import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:event_any_where_app/api/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventService {
  final String _baseUrl = '${ApiConstants.baseApiUrl}/event';
  final String _categoriesUrl = '${ApiConstants.baseApiUrl}/category';
  final String _apiUrl = '${ApiConstants.baseApiUrl}/event/detail';

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception("Access token is missing");
      }

      final response = await http.delete(
        Uri.parse('$_baseUrl/delete/$eventId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete event');
      }
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  Future<Map<String, dynamic>> getEventById(String eventId) async {
    try {
      final response = await http.get(Uri.parse('$_apiUrl/$eventId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('event')) {
          return data['event'] as Map<String, dynamic>;
        } else {
          throw Exception('Invalid response format.');
        }
      } else {
        throw Exception('Failed to load event details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading event details: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getEventsByCurrentUser() async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception("Access token not found");
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/organizer'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('events')) {
          return List<Map<String, dynamic>>.from(data['events']);
        } else {
          throw Exception('Invalid response format.');
        }
      } else {
        throw Exception('Failed to fetch events: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception("Access token not found");
      }

      final response = await http.get(
        Uri.parse('$_categoriesUrl/list'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<bool> createEvent({
    required String title,
    required String description,
    required String location,
    required String date,
    required String categoryId,
    required List<File> images,
    double price = 0,
  }) async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception("Access token not found");
      }

      final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/add'))
        ..headers['Authorization'] = 'Bearer $accessToken'
        ..fields['title'] = title
        ..fields['description'] = description
        ..fields['location'] = location
        ..fields['date'] = date
        ..fields['category_id'] = categoryId;

      for (final image in images) {
        request.files.add(await http.MultipartFile.fromPath(
          'images',
          image.path,
          filename: basename(image.path),
        ));
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Failed to create event: $responseBody');
      }
    } catch (e) {
      throw Exception('Error creating event: $e');
    }
  }

  Future<bool> updateEvent({
    required String id,
    required String title,
    required String description,
    required String location,
    required String date,
    String? imagePath,
  }) async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        throw Exception("Access token not found");
      }

      final request =
          http.MultipartRequest('PUT', Uri.parse('$_baseUrl/update/$id'))
            ..headers['Authorization'] = 'Bearer $accessToken'
            ..fields['title'] = title
            ..fields['description'] = description
            ..fields['location'] = location
            ..fields['date'] = date;

      if (imagePath != null && imagePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'images',
          imagePath,
          filename: basename(imagePath),
        ));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Failed to update event: $responseBody');
      }
    } catch (e) {
      throw Exception('Error updating event: $e');
    }
  }
}
