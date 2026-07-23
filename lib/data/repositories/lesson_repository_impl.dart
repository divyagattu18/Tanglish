import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/firestore_datasource.dart';

class LessonRepositoryImpl implements LessonRepository {
  final FirestoreDataSource _dataSource;

  const LessonRepositoryImpl(this._dataSource);

  @override
  Future<List<LessonEntity>> getLessonsByCategory(String category) =>
      _dataSource.getLessonsByCategory(category);

  @override
  Future<List<String>> getCategories() => _dataSource.getCategories();

  @override
  Future<LessonEntity?> getLessonById(String lessonId) =>
      _dataSource.getLessonById(lessonId);
}
