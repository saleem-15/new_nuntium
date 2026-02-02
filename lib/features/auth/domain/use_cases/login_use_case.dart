import 'package:dartz/dartz.dart';
import 'package:new_nuntium/core/errors/failures.dart';

import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Either<Failure, UserEntity>> call(String email, String password) {
    return _authRepository.login(email, password);
  }
}