import 'package:flutter/material.dart';
import 'package:event_any_where_app/models/event_model.dart';
import 'package:event_any_where_app/services/filter_service.dart';

class FilterViewModel extends ChangeNotifier {
  final FilterService _eventService = FilterService();

  List<EventModel> _eventList = [];
  String _error = "";
  bool _isLoading = false;

  List<EventModel> get eventList => _eventList;
  String get error => _error;
  bool get isLoading => _isLoading;

  Future<void> fetchFilteredEvents({
    String? categoryId,
    String? dateOption,
    String? location,
  }) async {
    _isLoading = true;
    _error = ""; // Xóa lỗi cũ
    notifyListeners();

    try {
      _eventList = await _eventService.fetchFilteredEvents(
        categoryId: categoryId ?? "",
        dateOption: dateOption ?? "",
        location: location ?? "",
      );
    } catch (e) {
      _error = "Failed to fetch events: $e"; // Lưu lỗi
      _eventList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
