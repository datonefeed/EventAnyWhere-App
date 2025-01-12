import 'package:flutter/material.dart';
import '../../../../services/session_service.dart';

class SessionViewModel extends ChangeNotifier {
  final SessionService _sessionService = SessionService();

  List<dynamic> _sessions = [];
  List<dynamic> get sessions => _sessions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

// lấy tất cả session đã tạo
  Future<void> fetchSessions(String eventId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final fetchedSessions = await _sessionService.getSessionsByEvent(eventId);
      _sessions = fetchedSessions;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//tạo session
  Future<bool> createSession({
    required String eventId,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String location,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final success = await _sessionService.createSession(
        eventId: eventId,
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        location: location,
      );
      if (success) {
        // Có thể fetch lại danh sách session sau khi thêm mới nếu cần
        await fetchSessions(eventId);
      }
      return success;
    } catch (error) {
      _errorMessage = error.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
