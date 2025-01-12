import 'package:flutter/material.dart';
import 'package:event_any_where_app/services/session_service.dart';

class UpdateSessionViewmodel extends ChangeNotifier {
  final SessionService _sessionService = SessionService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Hàm cập nhật session
  Future<void> updateSession({
    required String sessionId,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String location,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _sessionService.updateSession(
        sessionId: sessionId,
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        location: location,
      );
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
