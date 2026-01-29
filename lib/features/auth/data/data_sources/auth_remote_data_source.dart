import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_nuntium/core/utils/app_logger.dart';

import '../../../../core/errors/app_exception.dart';

abstract class AuthRemoteDataSource {
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(String email, String password);
  Future<User> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Stream<User?> get userStream;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final _googleSignIn = GoogleSignIn.instance;
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

  @override
  Future<User> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize(
        serverClientId: dotenv.env['SERVER_CLIENT_ID'],
      );

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      AppLogger.i("Google Sign-In Successful: ${userCredential.user?.email}");
      return userCredential.user!;
    } catch (e) {
      AppLogger.e("Google Sign-In Error in DataSource", e);
      rethrow;
    }
  }

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

  @override
  Future<void> resetPassword(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
