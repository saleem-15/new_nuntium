import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/app_exception.dart';

abstract class AuthRemoteDataSource {
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(String email, String password);
  Future<void> signOut(); 
  Stream<User?> get userStream;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  Future<User> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw AppException(e.code); 
    }
  }

  // تنفيذ دالة إنشاء الحساب الجديد
  @override
  Future<User> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      // تحويل أكواد خطأ فايربيز (مثل email-already-in-use) إلى AppException
      throw AppException(e.code);
    }
  }

  // تنفيذ دالة تسجيل الخروج
  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AppException("logout_failed");
    }
  }

  @override
  Stream<User?> get userStream => _firebaseAuth.authStateChanges();
}