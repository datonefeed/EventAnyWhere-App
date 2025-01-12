import 'package:flutter/foundation.dart';
import 'package:event_any_where_app/services/recommend_service.dart';

class RecommendViewModel extends ChangeNotifier {
  final RecommendService _recommendService = RecommendService();
  List<dynamic> _recommendations = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<dynamic> get recommendations => _recommendations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRecommendations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _recommendations = await _recommendService.fetchRecommendations();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
