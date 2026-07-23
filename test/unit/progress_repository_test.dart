import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tanglish/data/datasources/firestore_datasource.dart';
import 'package:tanglish/data/models/progress_model.dart';
import 'package:tanglish/data/repositories/progress_repository_impl.dart';
import 'package:tanglish/domain/entities/progress_entity.dart';

@GenerateMocks([FirestoreDataSource])
import 'progress_repository_test.mocks.dart';

void main() {
  late MockFirestoreDataSource mockDs;
  late ProgressRepositoryImpl repo;

  setUp(() {
    mockDs = MockFirestoreDataSource();
    repo = ProgressRepositoryImpl(mockDs);
  });

  final progress = ProgressEntity(
    uid: 'uid_123',
    lessonId: 'family_001',
    completed: true,
    score: 100,
    completedDate: DateTime(2024, 6, 15),
  );

  group('ProgressRepositoryImpl.markLessonComplete', () {
    test('delegates to data source', () async {
      when(mockDs.markLessonComplete(progress))
          .thenAnswer((_) async {});

      await repo.markLessonComplete(progress);

      verify(mockDs.markLessonComplete(progress)).called(1);
    });
  });

  group('ProgressRepositoryImpl.isLessonCompleted', () {
    test('returns true for completed lesson', () async {
      when(mockDs.isLessonCompleted('uid_123', 'family_001'))
          .thenAnswer((_) async => true);

      final result = await repo.isLessonCompleted('uid_123', 'family_001');

      expect(result, isTrue);
    });

    test('returns false for incomplete lesson', () async {
      when(mockDs.isLessonCompleted('uid_123', 'school_001'))
          .thenAnswer((_) async => false);

      final result = await repo.isLessonCompleted('uid_123', 'school_001');

      expect(result, isFalse);
    });
  });

  group('ProgressRepositoryImpl.getUserProgress', () {
    test('returns list of progress from data source', () async {
      final model = ProgressModel(
        uid: 'uid_123',
        lessonId: 'family_001',
        completed: true,
        score: 100,
        completedDate: DateTime(2024, 6, 15),
      );
      when(mockDs.getUserProgress('uid_123'))
          .thenAnswer((_) async => [model]);

      final result = await repo.getUserProgress('uid_123');

      expect(result, hasLength(1));
      expect(result.first.lessonId, equals('family_001'));
    });
  });
}
