import 'package:flutter/material.dart';
import 'package:event_any_where_app/services/event_service.dart';

class UpdateEventViewModel with ChangeNotifier {
  final EventService _service = EventService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> updateEvent({
    required String id,
    required String title,
    required String description,
    required String location,
    required String date,
    String? imagePath,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _service.updateEvent(
        id: id,
        title: title,
        description: description,
        location: location,
        date: date,
        imagePath: imagePath,
      );

      if (!success) {
        _errorMessage = 'Failed to update event';
        print('Error: Update event failed on server.');
      }
    } catch (e, stackTrace) {
      _errorMessage = 'Exception: $e';
      print('Exception caught: $e');
      print('Stack Trace: $stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
