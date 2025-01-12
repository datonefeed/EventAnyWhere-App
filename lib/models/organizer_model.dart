class Organizer {
  final String id;
  final String name;
  final String image;

  Organizer({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
