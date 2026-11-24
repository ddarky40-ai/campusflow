class TaskItem {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String course;
  final bool isCompleted;

  const TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.course,
    this.isCompleted = false,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    final rawDate = json['dueDate'];
    final rawCompleted = json['isCompleted'];

    return TaskItem(
      id: json['id'].toString(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      dueDate: rawDate is DateTime
          ? rawDate
          : DateTime.tryParse(rawDate?.toString() ?? '') ?? DateTime.now(),
      course: json['course']?.toString() ?? '',
      isCompleted: rawCompleted is bool
          ? rawCompleted
          : rawCompleted.toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'course': course,
      'isCompleted': isCompleted,
    };
  }

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? course,
    bool? isCompleted,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      course: course ?? this.course,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
