import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  // ignore: unused_field
  final AuthRepository _authRepository;

  SignInWithGoogleUseCase(this._authRepository);

  Future<void> call() {
    return _authRepository.signInWithGoogle();
  }
}
