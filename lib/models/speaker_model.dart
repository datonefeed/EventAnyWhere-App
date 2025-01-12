class Speaker {
  final String id;
  final String name;
  final String position;
  final String bio;
  final String profileImageUrl;

  Speaker({
    required this.id,
    required this.name,
    required this.position,
    required this.bio,
    required this.profileImageUrl,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      position: json['position'] ?? 'No Position',
      bio: json['bio'] ?? 'No Bio',
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }
}
