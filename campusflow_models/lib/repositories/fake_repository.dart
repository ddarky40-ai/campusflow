import '../models/task.dart';
import '../models/course.dart';
import '../models/user.dart';

class FakeRepository {
  Future<List<Task>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Task(
        id: '1',
        title: 'Terminer le TP Flutter',
        description: 'Réaliser les exercices de programmation mobile.',
        dueDate: DateTime(2026, 11, 28),
        courseId: '1',
      ),
      Task(
        id: '2',
        title: 'Réviser les réseaux',
        description: 'Préparer le prochain cours.',
        dueDate: DateTime(2026, 11, 30),
        courseId: '2',
      ),
    ];
  }

  Future<List<Course>> getCourses() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      Course(
        id: '1',
        name: 'Programmation Mobile',
        description: 'Développement mobile avec Flutter.',
      ),
      Course(
        id: '2',
        name: 'Réseaux',
        description: 'Introduction aux réseaux informatiques.',
      ),
    ];
  }

  Future<List<User>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      User(
        id: '1',
        fullName: 'Aminata Ouédraogo',
        email: 'aminata@example.com',
        institution: 'Université Aube Nouvelle',
        program: 'Master 1 MSI',
      ),
    ];
  }

  Future<Task> getTaskById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final tasks = await getTasks();

    return tasks.firstWhere(
      (task) => task.id == id,
      orElse: () => throw StateError('Tâche introuvable : $id'),
    );
  }
}
