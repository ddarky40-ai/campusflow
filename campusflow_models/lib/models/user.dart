class User {
  final String id;
  final String fullName;
  final String email;
  final String institution;
  final String program;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.institution,
    required this.program,
  });

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? institution,
    String? program,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      institution: institution ?? this.institution,
      program: program ?? this.program,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      institution: json['institution'] as String,
      program: json['program'] as String,
    );
  }
}
