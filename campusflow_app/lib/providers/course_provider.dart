import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/course.dart';
import 'task_provider.dart';

final coursesProvider =
    FutureProvider.autoDispose<List<Course>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  final data = await api.getCourses();
  return data
      .map((item) =>
          Course.fromJson(Map<String, dynamic>.from(item)))
      .toList();
});
