import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tanglish/data/datasources/auth_remote_datasource.dart';
import 'package:tanglish/data/models/user_model.dart';
import 'package:tanglish/data/repositories/auth_repository_impl.dart';

@GenerateMocks([AuthRemoteDataSource])
import 'auth_repository_test.mocks.dart';

void main() {
  late MockAuthRemoteDataSource mockDs;
  late AuthRepositoryImpl repo;

  final testUser = UserModel(
    uid: 'uid_test_123',
    displayName: 'Priya',
    email: 'priya@example.com',
    createdAt: DateTime(2024, 6, 1),
    streak: 5,
    xp: 50,
  );

  setUp(() {
    mockDs = MockAuthRemoteDataSource();
    repo = AuthRepositoryImpl(mockDs);
  });

  group('AuthRepositoryImpl.signInWithGoogle', () {
    test('delegates to data source and returns UserEntity', () async {
      when(mockDs.signInWithGoogle()).thenAnswer((_) async => testUser);

      final result = await repo.signInWithGoogle();

      expect(result.uid, equals('uid_test_123'));
      expect(result.displayName, equals('Priya'));
      verify(mockDs.signInWithGoogle()).called(1);
    });

    test('propagates exception on failure', () {
      when(mockDs.signInWithGoogle())
          .thenThrow(const AuthException('Cancelled'));

      expect(repo.signInWithGoogle(), throwsA(isA<AuthException>()));
    });
  });

  group('AuthRepositoryImpl.signOut', () {
    test('delegates to data source', () async {
      when(mockDs.signOut()).thenAnswer((_) async {});

      await repo.signOut();

      verify(mockDs.signOut()).called(1);
    });
  });

  group('AuthRepositoryImpl.getCurrentUser', () {
    test('returns null when no user is signed in', () async {
      when(mockDs.getCurrentUser()).thenAnswer((_) async => null);

      final result = await repo.getCurrentUser();

      expect(result, isNull);
    });

    test('returns UserEntity when signed in', () async {
      when(mockDs.getCurrentUser()).thenAnswer((_) async => testUser);

      final result = await repo.getCurrentUser();

      expect(result?.uid, equals('uid_test_123'));
    });
  });

  group('AuthRepositoryImpl.authStateChanges', () {
    test('streams user from data source', () async {
      when(mockDs.authStateChanges)
          .thenAnswer((_) => Stream.value(testUser));

      final user = await repo.authStateChanges.first;

      expect(user?.uid, equals('uid_test_123'));
    });

    test('streams null when signed out', () async {
      when(mockDs.authStateChanges)
          .thenAnswer((_) => Stream.value(null));

      final user = await repo.authStateChanges.first;

      expect(user, isNull);
    });
  });
}
