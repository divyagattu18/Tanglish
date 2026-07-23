import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  const AuthRepositoryImpl(this._dataSource);

  @override
  Stream<UserEntity?> get authStateChanges => _dataSource.authStateChanges;

  @override
  Future<UserEntity> signInWithGoogle() => _dataSource.signInWithGoogle();

  @override
  Future<UserEntity> signInWithApple() => _dataSource.signInWithApple();

  @override
  Future<UserEntity> signInWithEmail(String email, String password) =>
      _dataSource.signInWithEmail(email, password);

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  Future<UserEntity?> getCurrentUser() => _dataSource.getCurrentUser();
}
