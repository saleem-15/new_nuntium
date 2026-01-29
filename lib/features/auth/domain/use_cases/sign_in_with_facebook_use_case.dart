import '../repositories/auth_repository.dart';

class SignInWithFacebookUseCase {
  final AuthRepository _authRepository;

  SignInWithFacebookUseCase(this._authRepository);

  Future<void> call() {
    return _authRepository.signInWithFacebook();
  }
}
