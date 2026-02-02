import 'package:dartz/dartz.dart';
import 'package:new_nuntium/core/errors/failures.dart';

import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _authRepository;

  ResetPasswordUseCase(this._authRepository);


  
  Future<Either<Failure, void>> call(String email) async {
    return await _authRepository.resetPassword(email);
  }
}
