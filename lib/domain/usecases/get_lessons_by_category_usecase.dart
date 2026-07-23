import '../entities/lesson_entity.dart';
import '../repositories/lesson_repository.dart';

class GetLessonsByCategoryUseCase {
  final LessonRepository _repository;
  const GetLessonsByCategoryUseCase(this._repository);

  Future<List<LessonEntity>> call(String category) =>
      _repository.getLessonsByCategory(category);
}
