import '../../domain/entities/progress_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/firestore_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final FirestoreDataSource _dataSource;

  const ProgressRepositoryImpl(this._dataSource);

  @override
  Future<List<ProgressEntity>> getUserProgress(String uid) =>
      _dataSource.getUserProgress(uid);

  @override
  Future<void> markLessonComplete(ProgressEntity progress) =>
      _dataSource.markLessonComplete(progress);

  @override
  Future<bool> isLessonCompleted(String uid, String lessonId) =>
      _dataSource.isLessonCompleted(uid, lessonId);

  @override
  Stream<List<ProgressEntity>> watchUserProgress(String uid) =>
      _dataSource.watchUserProgress(uid);
}
