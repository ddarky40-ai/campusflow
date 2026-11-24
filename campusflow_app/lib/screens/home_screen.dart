import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/task_item.dart';
import '../providers/task_provider.dart';

enum TaskFilter { all, todo, done, overdue }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TaskFilter _filter = TaskFilter.all;
  final Set<String> _togglingTaskIds = {};
  String? _selectedTaskId;

  Future<void> _toggleTask(String id) async {
    if (_togglingTaskIds.contains(id)) return;
    setState(() => _togglingTaskIds.add(id));
    try {
      await ref.read(taskProvider.notifier).toggleTask(id);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Modification impossible : $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _togglingTaskIds.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskProvider);
    final todoTasks = ref.watch(todoTasksProvider);
    final doneTasks = ref.watch(doneTasksProvider);
    final overdueTasks = ref.watch(overdueTasksProvider);
    final AsyncValue<List<TaskItem>> visibleTasksAsync =
        switch (_filter) {
      TaskFilter.todo => todoTasks,
      TaskFilter.done => doneTasks,
      TaskFilter.overdue => overdueTasks,
      TaskFilter.all => tasksAsync,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes échéances'),
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Impossible de charger les échéances.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.read(taskProvider.notifier).loadTasks(),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (tasks) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth >= 840;
              final selectedTask = visibleTasksAsync.asData?.value
                  .where((task) => task.id == _selectedTaskId)
                  .firstOrNull;

              final list = visibleTasksAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    const Center(child: Text('Erreur de filtrage.')),
                data: (visibleTasks) => tasks.isEmpty
                    ? const Center(
                        child: Text('Aucune tâche disponible.'))
                    : visibleTasks.isEmpty
                        ? const Center(
                            child:
                                Text('Aucune tâche dans cette catégorie.'))
                        : ListView.separated(
                            padding: const EdgeInsets.all(12),
                            itemCount: visibleTasks.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final task = visibleTasks[index];
                              final isSelected =
                                  isTablet && task.id == _selectedTaskId;
                              return Card(
                                color: isSelected
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : null,
                                child: ListTile(
                                  leading: Checkbox(
                                    value: task.isCompleted,
                                    onChanged: _togglingTaskIds
                                            .contains(task.id)
                                        ? null
                                        : (_) => _toggleTask(task.id),
                                  ),
                                  title: Text(
                                    task.title,
                                    style: TextStyle(
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${task.course} • ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                                  ),
                                  trailing:
                                      const Icon(Icons.chevron_right),
                                  onTap: () {
                                    if (isTablet) {
                                      setState(
                                          () => _selectedTaskId = task.id);
                                    } else {
                                      context.push('/taches/${task.id}');
                                    }
                                  },
                                ),
                              );
                            },
                          ),
              );

              return Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        _filterChip('Toutes', TaskFilter.all),
                        _filterChip('À faire', TaskFilter.todo),
                        _filterChip('Faites', TaskFilter.done),
                        _filterChip('En retard', TaskFilter.overdue),
                      ],
                    ),
                  ),
                  Expanded(
                    child: isTablet
                        ? Row(
                            children: [
                              Expanded(child: list),
                              const VerticalDivider(width: 1),
                              Expanded(
                                child: selectedTask == null
                                    ? const Center(
                                        child: Text(
                                            'Sélectionnez une tâche'))
                                    : _TabletTaskDetail(
                                        task: selectedTask,
                                        onToggle: () =>
                                            _toggleTask(selectedTask.id),
                                        updating: _togglingTaskIds
                                            .contains(selectedTask.id),
                                      ),
                              ),
                            ],
                          )
                        : list,
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push<bool>('/taches/nouvelle');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _filterChip(String label, TaskFilter filter) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _filter == filter,
        onSelected: (_) => setState(() => _filter = filter),
      ),
    );
  }
}

class _TabletTaskDetail extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onToggle;
  final bool updating;

  const _TabletTaskDetail({
    required this.task,
    required this.onToggle,
    required this.updating,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(task.description.isEmpty
              ? 'Aucune description'
              : task.description),
          const SizedBox(height: 16),
          Text('Cours : ${task.course}'),
          const SizedBox(height: 8),
          Text(
            'Date limite : ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Tâche terminée'),
            value: task.isCompleted,
            onChanged: updating ? null : (_) => onToggle(),
          ),
          if (!task.isCompleted)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: updating ? null : onToggle,
                child: const Text('Marquer comme fait'),
              ),
            ),
        ],
      ),
    );
  }
}
