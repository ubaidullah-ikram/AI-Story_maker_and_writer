class StoryModel {
  final int? id;
  final String title;
  final String description;
  final String category; // 'Story Generator', 'Essay Writer', 'Script Generator'
  final DateTime createdAt;

  StoryModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert from Map
  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
