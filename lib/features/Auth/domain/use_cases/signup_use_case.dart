import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  SignupUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<UserEntity> call(String email, String password, String name) {
    return _authRepository.register(email, password, name);
  }
}
