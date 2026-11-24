import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:campusflow_app/models/task_item.dart';
import 'package:campusflow_app/providers/task_provider.dart';
import 'package:campusflow_app/screens/home_screen.dart';

class FakeTaskNotifier extends TaskNotifier {
  @override
  Future<List<TaskItem>> build() async {
    return [
      TaskItem(
        id: '1',
        title: 'Rendre le TP Programmation Mobile',
        description: 'Dépôt du travail pratique.',
        course: 'Programmation Mobile',
        dueDate: DateTime(2026, 11, 22),
        isCompleted: false,
      ),
    ];
  }
}

void main() {
  testWidgets('CampusFlow affiche les échéances', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskProvider.overrideWith(FakeTaskNotifier.new),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Mes échéances'), findsOneWidget);
    expect(find.text('Rendre le TP Programmation Mobile'), findsOneWidget);
    expect(find.text('Toutes'), findsOneWidget);
    expect(find.text('À faire'), findsOneWidget);
  });
}
