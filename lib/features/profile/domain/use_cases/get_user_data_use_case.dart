import 'package:dartz/dartz.dart';
import 'package:new_nuntium/core/errors/failures.dart';

import '../entities/user_entity.dart';
import '../repository/profile_repository.dart';

class GetUserDataUseCase {
  final ProfileRepository repository;
  GetUserDataUseCase(this.repository);

  Either<Failure, UserEntity> call() {
    return repository.getCurrentUser();
  }
}