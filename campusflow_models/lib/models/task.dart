class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String courseId;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.courseId,
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? courseId,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      courseId: courseId ?? this.courseId,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      courseId: json['courseId'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
