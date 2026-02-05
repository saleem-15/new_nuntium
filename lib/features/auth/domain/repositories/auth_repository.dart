import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_nuntium/core/errors/failures.dart';

import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> register(String email, String password, String name);
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure,void>> signOut();
  Future<Either<Failure,void>> resetPassword(String email);
  Future<Either<Failure, void>> changePassword(String currentPassword, String newPassword);
  Stream<UserEntity?> get authStateChanges;
}
