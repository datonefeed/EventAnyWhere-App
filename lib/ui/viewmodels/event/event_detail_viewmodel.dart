import 'package:flutter/material.dart';
import 'package:event_any_where_app/models/event_detail_model.dart';
import 'package:event_any_where_app/repositories/event_detail_repository.dart';

class EventDetailViewModel extends ChangeNotifier {
  final EventDetailRepository _eventRepository = EventDetailRepository();
  EventDetail? event;
  bool isLoading = true;

  Future<void> fetchEvent(String eventId) async {
    isLoading = true;
    notifyListeners();

    try {
      event = await _eventRepository.getEventById(eventId);
    } catch (e) {
      print('Error fetching event details: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
