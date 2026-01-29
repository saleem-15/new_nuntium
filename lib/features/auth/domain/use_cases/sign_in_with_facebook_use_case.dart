import 'package:new_nuntium/core/errors/app_exception.dart';

import '../repositories/auth_repository.dart';

class SignInWithFacebookUseCase {
  // ignore: unused_field
  final AuthRepository _authRepository;

  SignInWithFacebookUseCase(this._authRepository);

  Future<void> call() {
    // return _authRepository.signInWithFacebook();
    throw AppException('Un implemented');
  }
}
