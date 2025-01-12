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

  // Hàm lấy token từ SharedPreferences
  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Hàm xóa sự kiện
  Future<void> deleteEvent(String eventId) async {
    try {
      // Lấy access_token từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');
      if (accessToken == null) {
        throw Exception("Access token is missing");
      }

      final response = await http.delete(
        Uri.parse('$_baseUrl/delete/$eventId'),
        headers: {
          'Authorization':
              'Bearer $accessToken', // Thêm access token vào header
          'Content-Type': 'application/json', // Thêm content type nếu cần
        },
      );

      if (response.statusCode == 200) {
        // Xóa sự kiện thành công
        print("Event deleted successfully");
      } else {
        // Nếu có lỗi xảy ra từ phía server
        throw Exception('Failed to delete event');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete event');
    }
  }

  // Lấy thông tin sự kiện theo ID
  Future<Map<String, dynamic>> getEventById(String eventId) async {
    final response = await http.get(Uri.parse('$_apiUrl/$eventId'));

    if (response.statusCode == 200) {
      // Parse dữ liệu từ API thành Map
      final data = json.decode(response.body);
      return data['event']; // Trả về thông tin sự kiện
    } else {
      throw Exception('Failed to load event details');
    }
  }

  // Phương thức lấy danh sách sự kiện
  Future<List<Map<String, dynamic>>> getEventsByCurrentUser() async {
    final url = Uri.parse('$_baseUrl/organizer');
    final accessToken = await _getAccessToken();

    if (accessToken == null) {
      throw Exception("Access token not found");
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final events = responseBody['events'] as List<dynamic>;
        return events
            .map((event) => event as Map<String, dynamic>)
            .toList(); // Trả về danh sách sự kiện
      } else {
        throw Exception('Failed to fetch events: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching events: $error');
    }
  }

  // Phương thức lấy danh sách danh mục sự kiện
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final url = Uri.parse('$_categoriesUrl/list');
    final accessToken = await _getAccessToken();

    if (accessToken == null) {
      throw Exception("Access token not found");
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching categories: $error');
    }
  }

  // Phương thức tạo sự kiện
  Future<bool> createEvent({
    required String title,
    required String description,
    required String location,
    required String date,
    required String categoryId,
    required List<File> images,
    double price = 0,
  }) async {
    final url = Uri.parse('$_baseUrl/add');
    final accessToken = await _getAccessToken();

    if (accessToken == null) {
      throw Exception("Access token not found");
    }

    final request = http.MultipartRequest('POST', url)
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

    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        print('Event created successfully');
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Failed to create event. Response: $responseBody');
        return false;
      }
    } catch (error) {
      print('Error creating event: $error');
      throw Exception('Error creating event: $error');
    }
  }

  // Phương thức update sự kiện
  Future<bool> updateEvent({
    required String id,
    required String title,
    required String description,
    required String location,
    required String date,
    String? imagePath,
  }) async {
    final url = Uri.parse('$_baseUrl/update/$id');
    final accessToken = await _getAccessToken();

    if (accessToken == null) {
      throw Exception("Access token not found");
    }

    final request = http.MultipartRequest('PUT', url)
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

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Event updated successfully');
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Failed to update event. Response: $responseBody');
        return false;
      }
    } catch (error) {
      print('Error updating event: $error');
      throw Exception('Error updating event: $error');
    }
  }
}
