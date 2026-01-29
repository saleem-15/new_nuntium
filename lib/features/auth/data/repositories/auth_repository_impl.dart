import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

/// تنفيذ مستودع المصادقة
/// هذا الكلاس مسؤول عن التنسيق بين مصدر البيانات وطبقة الـ Domain
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    // جلب بيانات المستخدم من Firebase عبر مصدر البيانات
    final firebaseUser = await _remoteDataSource.signInWithEmail(
      email,
      password,
    );

    // تحويل كائن Firebase User إلى UserEntity الخاص بالتطبيق
    return _mapFirebaseUserToEntity(firebaseUser);
  }

  @override
  Future<UserEntity> register(
    String email,
    String password,
    String name,
  ) async {
    // إنشاء حساب جديد
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
    return _mapFirebaseUserToEntity(updatedUser);
  }

  @override
  Future<User> signInWithGoogle() async {
    return await _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    return await _remoteDataSource.signOut();
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
  Future<void> resetPassword(String email) async {
    await _remoteDataSource.resetPassword(email);
  }
}
