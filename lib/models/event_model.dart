class EventModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String location;
  final String imageUrl;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      location: json['location'] as String,
      imageUrl: json['images'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'images': imageUrl,
    };
  }
}
