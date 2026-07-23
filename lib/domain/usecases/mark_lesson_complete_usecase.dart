import '../entities/progress_entity.dart';
import '../repositories/progress_repository.dart';

class MarkLessonCompleteUseCase {
  final ProgressRepository _repository;
  const MarkLessonCompleteUseCase(this._repository);

  Future<void> call(ProgressEntity progress) =>
      _repository.markLessonComplete(progress);
}
