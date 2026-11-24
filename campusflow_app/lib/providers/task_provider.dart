import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_item.dart';
import '../repositories/task_repository.dart';
import '../repositories/api_task_repository.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(
    storage: ref.watch(secureStorageProvider),
    onUnauthorized: () {
      ref.read(authProvider.notifier).unauthorized();
    },
  );
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return ApiTaskRepository(ref.watch(apiServiceProvider));
});

final taskProvider =
    AsyncNotifierProvider<TaskNotifier, List<TaskItem>>(
  TaskNotifier.new,
);

class TaskNotifier extends AsyncNotifier<List<TaskItem>> {
  @override
  Future<List<TaskItem>> build() {
    return ref.read(taskRepositoryProvider).getTasks();
  }

  Future<void> loadTasks() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(taskRepositoryProvider).getTasks(),
    );
  }

  Future<void> addTask(TaskItem task) async {
    try {
      final created =
          await ref.read(taskRepositoryProvider).createTask(task);
      final current = state.asData?.value ?? [];
      state = AsyncData([...current, created]);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> toggleTask(String id) async {
    try {
      final current = state.asData?.value ?? [];
      final matches = current.where((task) => task.id == id);
      if (matches.isEmpty) return;

      final task = matches.first;
      final updated = await ref.read(taskRepositoryProvider).updateTask(
        id,
        {'isCompleted': !task.isCompleted},
      );

      state = AsyncData([
        for (final item in current)
          if (item.id == id) updated else item,
      ]);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await ref.read(taskRepositoryProvider).deleteTask(id);
      final current = state.asData?.value ?? [];
      state = AsyncData(
        current.where((task) => task.id != id).toList(),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

final todoTasksProvider =
    Provider<AsyncValue<List<TaskItem>>>((ref) {
  final tasks = ref.watch(taskProvider);
  return tasks.whenData(
    (items) => items.where((task) => !task.isCompleted).toList(),
  );
});

final doneTasksProvider =
    Provider<AsyncValue<List<TaskItem>>>((ref) {
  final tasks = ref.watch(taskProvider);
  return tasks.whenData(
    (items) => items.where((task) => task.isCompleted).toList(),
  );
});

final overdueTasksProvider =
    Provider<AsyncValue<List<TaskItem>>>((ref) {
  final tasks = ref.watch(taskProvider);
  final now = DateTime.now();
  return tasks.whenData(
    (items) => items.where((task) {
      if (task.isCompleted) return false;
      final due =
          DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      final today = DateTime(now.year, now.month, now.day);
      return due.isBefore(today);
    }).toList(),
  );
});
