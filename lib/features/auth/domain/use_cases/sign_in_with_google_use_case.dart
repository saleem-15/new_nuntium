import 'package:new_nuntium/core/errors/app_exception.dart';

import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  // ignore: unused_field
  final AuthRepository _authRepository;

  SignInWithGoogleUseCase(this._authRepository);

  Future<void> call() {
    // return _authRepository.signInWithGoogle();
    throw AppException('Un implemented');
  }
}
