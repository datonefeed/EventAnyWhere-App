import 'package:flutter/material.dart';
import '../../../../../services/speaker_service.dart';

class SessionDetailViewModel extends ChangeNotifier {
  final SpeakerService _speakerService = SpeakerService();

  List<dynamic> _speakers = [];
  List<dynamic> get speakers => _speakers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchSpeakers(String sessionId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final fetchedSpeakers =
          await _speakerService.getSpeakersBySession(sessionId);
      _speakers = fetchedSpeakers;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
