import '../models/task_item.dart';
import '../services/api_service.dart';
import 'task_repository.dart';

class ApiTaskRepository implements TaskRepository {
  final ApiService apiService;

  ApiTaskRepository(this.apiService);

  @override
  Future<List<TaskItem>> getTasks() async {
    final data = await apiService.getTasks();
    return data
        .map((item) => TaskItem.fromJson(
            Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<TaskItem> createTask(TaskItem task) async {
    final data = await apiService.createTask(task.toJson());
    return TaskItem.fromJson(data);
  }

  @override
  Future<TaskItem> updateTask(
      String id, Map<String, dynamic> changes) async {
    final data = await apiService.updateTask(id, changes);
    return TaskItem.fromJson(data);
  }

  @override
  Future<void> deleteTask(String id) {
    return apiService.deleteTask(id);
  }
}
