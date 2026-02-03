import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_nuntium/core/errors/failures.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseAuth _firebaseAuth;

  ProfileRepositoryImpl(this._firebaseAuth);

  @override
  Either<Failure, UserEntity> getCurrentUser() {
    try {
      final user = _firebaseAuth.currentUser;

      if (user != null) {
        return Right(
          UserEntity(
            uid: user.uid,
            email: user.email ?? "",
            displayName: user.displayName,
            photoUrl: user.photoURL,
          ),
        );
      } else {
        return Left(AuthFailure("No user found"));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
