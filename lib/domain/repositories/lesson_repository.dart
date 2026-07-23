import '../entities/lesson_entity.dart';

abstract class LessonRepository {
  Future<List<LessonEntity>> getLessonsByCategory(String category);
  Future<List<String>> getCategories();
  Future<LessonEntity?> getLessonById(String lessonId);
}
