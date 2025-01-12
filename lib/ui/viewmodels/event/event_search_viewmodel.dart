import 'package:flutter/material.dart';
import 'package:event_any_where_app/services/event_search_service.dart';

class EventSearchViewModel extends ChangeNotifier {
  final EventSearchService _searchService = EventSearchService();
  List<dynamic> _events = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<dynamic> get events => _events;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> searchEvents(String keyword) async {
    if (keyword.isEmpty) {
      _events = [];
      _errorMessage = 'Please enter a search keyword.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _events = await _searchService.searchEvents(keyword);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
