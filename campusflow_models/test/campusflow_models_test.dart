import 'package:test/test.dart';
import 'package:campusflow_models/campusflow_models.dart';

void main() {
  group('Tests CampusFlow', () {
    test('copyWith crée une copie modifiée sans modifier l’original', () {
      final task = Task(
        id: '1',
        title: 'TP Flutter',
        description: 'Travail pratique',
        dueDate: DateTime(2026, 11, 28),
        courseId: '1',
      );

      final updatedTask = task.copyWith(isCompleted: true);

      expect(updatedTask.isCompleted, isTrue);
      expect(task.isCompleted, isFalse);
      expect(updatedTask.title, task.title);
    });

    test('fromJson construit correctement une tâche', () {
      final json = {
        'id': '1',
        'title': 'TP Flutter',
        'description': 'Travail pratique',
        'dueDate': '2026-11-28T00:00:00.000',
        'courseId': '1',
        'isCompleted': false,
      };

      final task = Task.fromJson(json);

      expect(task.id, '1');
      expect(task.title, 'TP Flutter');
      expect(task.isCompleted, isFalse);
    });

    test('une tâche inexistante déclenche une erreur attendue', () async {
      final repository = FakeRepository();

      await expectLater(
        repository.getTaskById('999'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
