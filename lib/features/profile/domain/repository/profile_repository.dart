import 'package:dartz/dartz.dart';
import 'package:new_nuntium/core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class ProfileRepository {
  Either<Failure, UserEntity> getCurrentUser();
}