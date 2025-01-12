import '../models/session_model.dart';
import '../models/speaker_model.dart';
import '../models/organizer_model.dart';

class EventDetail {
  final String id;
  final String title;
  final String image;
  final String description;
  final String date;
  final String location;
  final Organizer organizer;
  final List<Session> sessions;
  final List<Speaker> speakers;

  EventDetail({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.date,
    required this.location,
    required this.organizer,
    required this.sessions,
    required this.speakers,
  });

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    return EventDetail(
      id: json['id'] ?? '',
      title: json['title'] ?? 'No Title',
      image: json['image'] ?? '',
      description: json['description'] ?? 'No Description',
      date: json['date'] ?? '',
      location: json['location'] ?? 'No Location',
      organizer: json['organizer'] != null
          ? Organizer.fromJson(json['organizer'])
          : Organizer(id: '', name: 'No Organizer', image: ''),
      sessions: json['sessions'] != null
          ? (json['sessions'] as List).map((e) => Session.fromJson(e)).toList()
          : [],
      speakers: json['speakers'] != null
          ? (json['speakers'] as List).map((e) => Speaker.fromJson(e)).toList()
          : [],
    );
  }
}
