import 'package:flutter/material.dart';
import 'package:event_any_where_app/models/event_model.dart';
import 'package:event_any_where_app/services/filter_service.dart';

class FilterViewModel extends ChangeNotifier {
  final FilterService _eventService;

  FilterViewModel(this._eventService);

  List<EventModel> _eventList = [];
  String? _errorMessage;
  bool _isLoading = false;

  List<EventModel> get eventList => _eventList;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setEvents(List<EventModel> events) {
    _eventList = events;
    notifyListeners();
  }

  Future<void> fetchFilteredEvents({
    String? categoryId,
    String? dateOption,
    String? location,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final events = await _eventService.fetchFilteredEvents(
        categoryId: categoryId ?? "",
        dateOption: dateOption ?? "",
        location: location ?? "",
      );
      _setEvents(events);
    } catch (e) {
      _setError("An error occurred while fetching events. Please try again.");
      _setEvents([]);
    } finally {
      _setLoading(false);
    }
  }
}
