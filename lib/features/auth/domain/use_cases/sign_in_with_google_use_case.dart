import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_nuntium/core/errors/failures.dart';

import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  // ignore: unused_field
  final AuthRepository _authRepository;

  SignInWithGoogleUseCase(this._authRepository);

  Future<Either<Failure, User>> call() {
    return _authRepository.signInWithGoogle();
  }
}
