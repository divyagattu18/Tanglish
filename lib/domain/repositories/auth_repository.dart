import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Stream of auth state changes; emits null when signed out.
  Stream<UserEntity?> get authStateChanges;

  Future<UserEntity> signInWithGoogle();
  Future<UserEntity> signInWithApple();
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
}
