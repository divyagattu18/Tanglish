import '../entities/progress_entity.dart';

abstract class ProgressRepository {
  Future<List<ProgressEntity>> getUserProgress(String uid);
  Future<void> markLessonComplete(ProgressEntity progress);
  Future<bool> isLessonCompleted(String uid, String lessonId);
  Stream<List<ProgressEntity>> watchUserProgress(String uid);
}
