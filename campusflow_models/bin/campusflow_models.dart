import 'package:campusflow_models/campusflow_models.dart';

Future<void> main() async {
  final repository = FakeRepository();

  final tasks = await repository.getTasks();

  print('CampusFlow - ${tasks.length} tâches chargées');

  for (final task in tasks) {
    print('${task.title} - ${task.isCompleted ? "Terminée" : "À faire"}');
  }
}
