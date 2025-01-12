import 'package:flutter/material.dart';
import 'package:event_any_where_app/services/event_service.dart';
import 'package:event_any_where_app/models/event_model.dart';
import 'event_viewmodel.dart';

class EventManagementViewModel extends ChangeNotifier {
  final EventService _eventService = EventService();
  final EventViewModel _eventViewModel = EventViewModel();
  bool isLoading = true;
  bool isError = false;
  bool isDeleted = false;
  EventModel? event;
  String errorMessage = '';

  // Fetch event details by ID
  Future<void> fetchEventDetails(String eventId) async {
    try {
      isLoading = true;
      isError = false;
      errorMessage = '';
      notifyListeners();

      // Gọi API để lấy thông tin sự kiện
      final eventData = await _eventService.getEventById(eventId);
      event = EventModel.fromJson(eventData);
    } catch (e) {
      isError = true;
      errorMessage = 'Error loading event details';
      print("Error fetching event: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      isLoading = true;
      isDeleted = false;
      isError = false;
      errorMessage = '';
      notifyListeners();

      await _eventService.deleteEvent(eventId);
      isDeleted = true;
      _eventViewModel.fetchEvents();
      notifyListeners();
    } catch (e) {
      isError = true;
      errorMessage = 'Error deleting event';
      print("Error deleting event: $e");
    } finally {
      isLoading = false;
      _eventViewModel.fetchEvents();
      notifyListeners();
    }
  }
}
