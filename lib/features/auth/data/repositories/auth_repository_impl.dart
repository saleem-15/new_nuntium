import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_nuntium/core/errors/error_handler.dart';
import 'package:new_nuntium/core/errors/failures.dart';
import 'package:new_nuntium/core/network/network_info.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(OfflineFailure());
    }

    try {
      final firebaseUser = await _remoteDataSource.signInWithEmail(
        email,
        password,
      );

      // Convert Firebase 'User' into a 'UserEntity'
      return Right(_mapFirebaseUserToEntity(firebaseUser));
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String email,
    String password,
    String name,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(OfflineFailure());
    }

    try {
      final firebaseUser = await _remoteDataSource.signUpWithEmail(
        email,
        password,
      );

      // تحديث اسم المستخدم في Firebase بعد الإنشاء (اختياري)
      await firebaseUser.updateDisplayName(name);
      await firebaseUser.reload();

      final updatedUser = await _remoteDataSource.signInWithEmail(
        email,
        password,
      );
      return Right(_mapFirebaseUserToEntity(updatedUser));
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    if (!await _networkInfo.isConnected) {
      return Left(OfflineFailure());
    }

    try {
      final user = await _remoteDataSource.signInWithGoogle();

      return Right(user);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    if (!await _networkInfo.isConnected) {
      return Left(OfflineFailure());
    }

    try {
      await _remoteDataSource.signOut();
      return Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    // مراقبة تغييرات حالة تسجيل الدخول وتحويلها تلقائياً
    return _remoteDataSource.userStream.map((firebaseUser) {
      if (firebaseUser == null) return null;
      return _mapFirebaseUserToEntity(firebaseUser);
    });
  }

  /// دالة مساعدة (Helper) لتحويل كائن Firebase إلى كائن Entity
  /// هذا يضمن أن طبقة الـ Domain لا تعتمد على مكتبة Firebase مباشرة
  UserEntity _mapFirebaseUserToEntity(User user) {
    return UserEntity(
      uid: user.uid,
      email: user.email ?? "",
      displayName: user.displayName,
    );
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    if (!await _networkInfo.isConnected) {
      return Left(OfflineFailure());
    }
    try {
      await _remoteDataSource.resetPassword(email);

      return Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(OfflineFailure());
    }

    try {
      await _remoteDataSource.changePassword(currentPassword, newPassword);
      return const Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }
}
