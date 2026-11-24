class Course {
  final String id;
  final String name;
  final String professor;

  const Course({
    required this.id,
    required this.name,
    this.professor = '',
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'].toString(),
      name: json['name']?.toString() ?? '',
      professor: json['professor']?.toString() ?? '',
    );
  }
}
