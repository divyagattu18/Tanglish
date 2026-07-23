import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tanglish/data/datasources/firestore_datasource.dart';
import 'package:tanglish/data/models/lesson_model.dart';
import 'package:tanglish/data/repositories/lesson_repository_impl.dart';

@GenerateMocks([FirestoreDataSource])
import 'lesson_repository_test.mocks.dart';

void main() {
  late MockFirestoreDataSource mockDs;
  late LessonRepositoryImpl repo;

  const family001 = LessonModel(
    lessonId: 'family_001',
    category: 'Family',
    englishPhrase: 'Good morning Mom',
    teluguPhrase: 'శుభోదయం అమ్మ',
    transliteration: 'Shubhodhayam Amma',
    order: 1,
  );

  setUp(() {
    mockDs = MockFirestoreDataSource();
    repo = LessonRepositoryImpl(mockDs);
  });

  group('LessonRepositoryImpl.getLessonsByCategory', () {
    test('returns lessons from data source', () async {
      when(mockDs.getLessonsByCategory('Family'))
          .thenAnswer((_) async => [family001]);

      final result = await repo.getLessonsByCategory('Family');

      expect(result, hasLength(1));
      expect(result.first.lessonId, equals('family_001'));
      verify(mockDs.getLessonsByCategory('Family')).called(1);
    });

    test('returns empty list when no lessons exist', () async {
      when(mockDs.getLessonsByCategory('Family'))
          .thenAnswer((_) async => []);

      final result = await repo.getLessonsByCategory('Family');

      expect(result, isEmpty);
    });
  });

  group('LessonRepositoryImpl.getLessonById', () {
    test('returns null for non-existent lesson', () async {
      when(mockDs.getLessonById('nonexistent'))
          .thenAnswer((_) async => null);

      final result = await repo.getLessonById('nonexistent');

      expect(result, isNull);
    });

    test('returns lesson when it exists', () async {
      when(mockDs.getLessonById('family_001'))
          .thenAnswer((_) async => family001);

      final result = await repo.getLessonById('family_001');

      expect(result?.lessonId, equals('family_001'));
      expect(result?.englishPhrase, equals('Good morning Mom'));
    });
  });

  group('LessonRepositoryImpl.getCategories', () {
    test('returns categories from data source', () async {
      when(mockDs.getCategories()).thenAnswer(
        (_) async => ['Family', 'School', 'Playground'],
      );

      final result = await repo.getCategories();

      expect(result, hasLength(3));
      expect(result, containsAll(['Family', 'School', 'Playground']));
    });
  });
}
