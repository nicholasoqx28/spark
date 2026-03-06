enum Role { enthusiast, athlete, admin }

class AppUser {
  final String id;
  final String name;
  final String email;
  final Role role;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        role: _parseRole(json['role'] as String),
      );

  static Role _parseRole(String r) => switch (r) {
        'ADMIN' => Role.admin,
        'ATHLETE' => Role.athlete,
        _ => Role.enthusiast,
      };

  bool get isAdmin => role == Role.admin;
  bool get isAthlete => role == Role.athlete || role == Role.admin;

  String get roleLabel => switch (role) {
        Role.admin => 'ADMIN',
        Role.athlete => 'ATHLETE',
        Role.enthusiast => 'ENTHUSIAST',
      };
}
