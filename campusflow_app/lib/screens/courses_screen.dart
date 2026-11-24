import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/course_provider.dart';

class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes cours')),
      body: courses.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Impossible de charger les cours.'),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => ref.invalidate(coursesProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
        data: (items) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final course = items[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.menu_book_outlined),
                title: Text(course.name),
                subtitle: course.professor.isEmpty
                    ? null
                    : Text(course.professor),
              ),
            );
          },
        ),
      ),
    );
  }
}
