import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository _authRepository;

  SignInWithGoogleUseCase(this._authRepository);

  Future<void> call() {
    return _authRepository.signInWithGoogle();
  }
}
