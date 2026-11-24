import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  ConsumerState<TaskDetailScreen> createState() =>
      _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  bool _updating = false;
  bool _deleting = false;

  Future<void> _toggleTask(String id) async {
    if (_updating) return;
    setState(() => _updating = true);
    try {
      await ref.read(taskProvider.notifier).toggleTask(id);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Modification impossible : $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _updating = false);
    }
  }

  Future<void> _deleteTask(String id) async {
    if (_deleting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer cette tâche ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => _deleting = true);
    try {
      await ref.read(taskProvider.notifier).deleteTask(id);
      if (mounted) context.go('/taches');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Suppression impossible : $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskProvider);

    return tasksAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Détail')),
        body: const Center(child: Text('Impossible de charger la tâche.')),
      ),
      data: (tasks) {
        final matches =
            tasks.where((task) => task.id == widget.taskId);
        final task = matches.isEmpty ? null : matches.first;

        if (task == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Détail')),
            body: const Center(child: Text('Cette tâche n’existe plus.')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Détail de la tâche')),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                Text(task.description.isEmpty
                    ? 'Aucune description'
                    : task.description),
                const SizedBox(height: 16),
                Text('Cours : ${task.course}'),
                const SizedBox(height: 8),
                Text('Date limite : ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}'),
                const SizedBox(height: 20),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Tâche terminée'),
                  value: task.isCompleted,
                  onChanged: _updating ? null : (_) => _toggleTask(task.id),
                ),
                if (!task.isCompleted)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _updating
                          ? null
                          : () => _toggleTask(task.id),
                      child: const Text('Marquer comme fait'),
                    ),
                  ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: Text(_deleting
                        ? 'Suppression...'
                        : 'Supprimer la tâche'),
                    onPressed:
                        _deleting ? null : () => _deleteTask(task.id),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
