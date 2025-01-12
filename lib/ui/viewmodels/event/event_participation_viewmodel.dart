import 'package:flutter/material.dart';
import 'package:event_any_where_app/services/event_participation_service.dart';

class EventParticipationViewModel extends ChangeNotifier {
  final EventParticipationService _service = EventParticipationService();

  bool _hasJoined = false;
  bool get hasJoined => _hasJoined;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> checkJoinStatus(String eventId) async {
    _isLoading = true;
    notifyListeners();

    try {
      print("Checking join status for eventId: $eventId");
      _hasJoined = await _service.checkJoinStatus(eventId);
      print("Join status: $_hasJoined");
      _errorMessage = '';
    } catch (e) {
      _hasJoined = false;
      _errorMessage = e.toString();
      print("Error in checkJoinStatus: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> joinEvent(String eventId) async {
    _isLoading = true;
    notifyListeners();

    try {
      print("Joining event for eventId: $eventId");
      _hasJoined = await _service.joinEvent(eventId);
      print("Successfully joined event: $_hasJoined");
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      print("Error in joinEvent: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
