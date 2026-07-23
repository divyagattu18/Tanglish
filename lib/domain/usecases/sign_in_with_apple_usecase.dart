import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithAppleUseCase {
  final AuthRepository _repository;
  const SignInWithAppleUseCase(this._repository);

  Future<UserEntity> call() => _repository.signInWithApple();
}
