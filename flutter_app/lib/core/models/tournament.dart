class Tournament {
  final String id;
  final String title;
  final String sport;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final int maxTeams;
  final String status;
  final int registrationCount;

  const Tournament({
    required this.id,
    required this.title,
    required this.sport,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.maxTeams,
    required this.status,
    required this.registrationCount,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) => Tournament(
        id: json['id'] as String,
        title: json['title'] as String,
        sport: json['sport'] as String,
        description: json['description'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        location: json['location'] as String,
        maxTeams: json['maxTeams'] as int,
        status: json['status'] as String,
        registrationCount:
            (json['_count'] as Map<String, dynamic>?)?['registrations'] as int? ?? 0,
      );

  bool get isFull => registrationCount >= maxTeams;
}
