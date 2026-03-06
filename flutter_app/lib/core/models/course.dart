class Course {
  final String id;
  final String title;
  final String description;
  final String sport;
  final String level;
  final String? imageUrl;
  final int lessonCount;
  final int enrollmentCount;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.sport,
    required this.level,
    this.imageUrl,
    required this.lessonCount,
    required this.enrollmentCount,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    final count = json['_count'] as Map<String, dynamic>? ?? {};
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      sport: json['sport'] as String,
      level: json['level'] as String,
      imageUrl: json['imageUrl'] as String?,
      lessonCount: count['lessons'] as int? ?? 0,
      enrollmentCount: count['enrollments'] as int? ?? 0,
    );
  }
}
