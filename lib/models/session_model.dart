import '../models/speaker_model.dart';

class Session {
  final String id;
  final String title;
  final String startTime;
  final String endTime;
  final String location;
  final List<Speaker> sessionSpeakers;
  final String description;

  Session({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.sessionSpeakers,
    required this.description,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] ?? '',
      title: json['title'] ?? 'No Title',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      location: json['location'] ?? '',
      sessionSpeakers: json['sessionSpeakers'] != null
          ? (json['sessionSpeakers'] as List)
              .map((e) => Speaker.fromJson(e))
              .toList()
          : [],
      description: json['description'] ?? 'No Description',
    );
  }
}
