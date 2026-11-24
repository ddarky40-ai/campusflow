import '../models/task_item.dart';
import 'task_repository.dart';

class FakeTaskRepository implements TaskRepository {
  final List<TaskItem> _tasks = [];

  @override
  Future<List<TaskItem>> getTasks() async => List.from(_tasks);

  @override
  Future<TaskItem> createTask(TaskItem task) async {
    _tasks.add(task);
    return task;
  }

  @override
  Future<TaskItem> updateTask(
      String id, Map<String, dynamic> changes) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) throw Exception('Tâche introuvable');

    final old = _tasks[index];
    final updated = old.copyWith(
      title: changes['title'] as String?,
      description: changes['description'] as String?,
      course: changes['course'] as String?,
      isCompleted: changes['isCompleted'] as bool?,
      dueDate: changes['dueDate'] == null
          ? null
          : DateTime.parse(changes['dueDate'] as String),
    );
    _tasks[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
  }
}
