import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/task_item.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  const TaskFormScreen({super.key});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _course = 'Programmation Mobile';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  bool _saving = false;

  static const List<String> _courses = [
    'Programmation Mobile',
    'Gestion de projet',
    'Réseaux',
    'Bases de données',
    'Systèmes d\'information',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (selected != null) setState(() => _dueDate = selected);
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    final task = TaskItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      course: _course,
      dueDate: _dueDate,
      isCompleted: false,
    );

    setState(() => _saving = true);
    try {
      await ref.read(taskProvider.notifier).addTask(task);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tâche enregistrée'),
          ),
        );
        context.pop(true);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle tâche')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Le titre est obligatoire'
                      : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _course,
              decoration: const InputDecoration(labelText: 'Cours'),
              items: _courses
                  .map(
                    (course) => DropdownMenuItem(
                      value: course,
                      child: Text(course),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _course = value);
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date limite'),
              subtitle: Text(
                '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: _pickDate,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _saveTask,
              child: Text(_saving ? 'Enregistrement...' : 'Enregistrer la tâche'),
            ),
          ],
        ),
      ),
    );
  }
}
