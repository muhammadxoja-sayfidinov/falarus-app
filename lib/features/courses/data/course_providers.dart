import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'course_model.dart';
import 'firebase_course_repository.dart';

final courseRepositoryProvider = Provider<FirebaseCourseRepository>((ref) {
  return FirebaseCourseRepository();
});

final coursesProvider = FutureProvider<List<Course>>((ref) async {
  final repo = ref.watch(courseRepositoryProvider);
  return await repo.getCourses();
});
