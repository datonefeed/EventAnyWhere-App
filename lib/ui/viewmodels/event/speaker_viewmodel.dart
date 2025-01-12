import 'package:flutter/material.dart';
import 'package:event_any_where_app/services/speaker_service.dart';

class SpeakerViewModel extends ChangeNotifier {
  final SpeakerService _speakerService = SpeakerService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> addSpeaker(
      String sessionId, String email, String position) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _speakerService.addSpeaker(sessionId, email, position);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
