import '../models/task_item.dart';

abstract class TaskRepository {
  Future<List<TaskItem>> getTasks();
  Future<TaskItem> createTask(TaskItem task);
  Future<TaskItem> updateTask(String id, Map<String, dynamic> changes);
  Future<void> deleteTask(String id);
}
