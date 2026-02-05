import 'package:dartz/dartz.dart';
import 'package:new_nuntium/core/errors/failures.dart';
import 'package:new_nuntium/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await _repository.changePassword(currentPassword, newPassword);
  }
}
