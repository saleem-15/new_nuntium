import 'package:dartz/dartz.dart';
import 'package:new_nuntium/core/errors/failures.dart';

import '../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  Future<Either<Failure,void>> call() async {
    return await _authRepository.signOut();
  }
}