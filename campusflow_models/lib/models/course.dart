class Course {
  final String id;
  final String name;
  final String description;

  const Course({
    required this.id,
    required this.name,
    required this.description,
  });

  Course copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }
}
