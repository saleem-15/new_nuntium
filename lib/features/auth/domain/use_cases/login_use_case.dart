import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<UserEntity> call(String email, String password) {
    return _authRepository.signInWithEmail(email, password);
  }
}