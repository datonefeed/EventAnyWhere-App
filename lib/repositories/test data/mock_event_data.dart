import 'package:event_any_where_app/models/event_model.dart';

final List<EventModel> mockEventList = [
  EventModel.fromJson({
    'id': '1',
    'title': 'Flutter Workshop',
    'date': '10 Dec, 2024',
    'location': 'Online',
    'imageUrl': 'assets/images/devday.png',
  }),
  EventModel.fromJson({
    'id': '2',
    'title': 'Tech Conference 2024',
    'date': '20 Jan, 2024',
    'location': 'New York',
    'imageUrl': 'assets/images/devday.png',
  }),
];
