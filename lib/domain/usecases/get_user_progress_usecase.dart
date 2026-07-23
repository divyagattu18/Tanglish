import '../entities/progress_entity.dart';
import '../repositories/progress_repository.dart';

class GetUserProgressUseCase {
  final ProgressRepository _repository;
  const GetUserProgressUseCase(this._repository);

  Future<List<ProgressEntity>> call(String uid) =>
      _repository.getUserProgress(uid);
}
