import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/event_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();

  String? organizerName;
  String? title;
  String? description;
  String? location;
  String? dateTime;
  String? selectedCategory;
  List<File> eventImages = [];

  // Danh sách danh mục sự kiện
  List<Map<String, dynamic>> categories = [];

  // Danh sách sự kiện
  List<Map<String, dynamic>> events = [];

  // Trạng thái
  bool isLoading = false;
  String errorMessage = '';

  // Constructor
  EventViewModel() {
    fetchCategories();
    fetchEvents();
  }

  String? get date {
    if (dateTime == null) return null;
    return dateTime!.split(' ')[1];
  }

  String? get time {
    if (dateTime == null) return null;
    return dateTime!.split(' ')[0];
  }

  // Phương thức để lấy user_id từ SharedPreferences
  Future<String?> _getOrganizerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  /// Lấy danh sách danh mục từ API
  Future<void> fetchCategories() async {
    isLoading = true;
    final ogname = await _getOrganizerName();
    organizerName = ogname;
    notifyListeners();
    try {
      categories = await _eventService.getAllCategories();
    } catch (error) {
      errorMessage = "Failed to fetch categories: $error";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Cập nhật danh mục được chọn
  void updateSelectedCategory(String? newCategory) {
    selectedCategory = newCategory;
    notifyListeners();
  }

  /// Hàm chọn ảnh cho sự kiện
  Future<void> pickEventImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        eventImages.add(File(pickedFile.path));
        notifyListeners();
      }
    } catch (error) {
      errorMessage = "Error selecting image: $error";
      notifyListeners();
    }
  }

  /// Xóa ảnh khỏi danh sách ảnh sự kiện
  void removeEventImage(int index) {
    if (index >= 0 && index < eventImages.length) {
      eventImages.removeAt(index);
      notifyListeners();
    }
  }

  /// Cập nhật dữ liệu cho các trường thông tin sự kiện
  void updateEventDetails({
    required String eventTitle,
    required String eventDescription,
    required String eventLocation,
    required String eventDateTime,
  }) {
    title = eventTitle;
    description = eventDescription;
    location = eventLocation;
    dateTime = eventDateTime;
    notifyListeners();
  }

  /// Hàm gửi dữ liệu sự kiện qua API
  Future<bool> createEvent() async {
    if (title == null ||
        description == null ||
        location == null ||
        dateTime == null ||
        selectedCategory == null) {
      errorMessage = "All fields must be filled out.";
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final success = await _eventService.createEvent(
        title: title!,
        description: description!,
        location: location!,
        date: dateTime!,
        categoryId: selectedCategory!,
        images: eventImages,
      );

      if (success) {
        clearEventData();
        await fetchEvents();
        return true;
      } else {
        errorMessage = "Failed to create event.";
        return false;
      }
    } catch (error) {
      errorMessage = "Error: $error";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Hàm lấy sự kiện từ API
  Future<void> fetchEvents() async {
    errorMessage = '';
    isLoading = true;
    notifyListeners();
    try {
      events = await _eventService.getEventsByCurrentUser();
    } catch (error) {
      errorMessage = "Error fetching events: $error";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Xóa dữ liệu sau khi gửi sự kiện thành công
  void clearEventData() {
    title = null;
    description = null;
    location = null;
    dateTime = null;
    selectedCategory = null;
    eventImages.clear();
    errorMessage = '';
    notifyListeners();
  }

  Future<void> clearEventsList() async {
    events = [];
    notifyListeners();
  }
}
