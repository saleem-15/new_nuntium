import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:new_nuntium/core/constants/constanst.dart';
import 'package:new_nuntium/core/resources/app_strings.dart';

import '../../../../core/errors/app_exception.dart';

abstract class AuthRemoteDataSource {
  Future<User> signInWithEmail(String email, String password);
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signUpWithEmail(String email, String password);
  Future<void> signOut();
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

  @override
  Future<User> signInWithGoogle() async {
    try {
      _googleSignIn.initialize(serverClientId: Constants.googleServerClientId);
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign In Firebase using
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      return userCredential.user!;
    } catch (e) {
      log(e.toString());
      throw AppException(AppStrings.googleSignInFailed);
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    try {
      // 1. طلب تسجيل الدخول من فيسبوك
      final LoginResult result = await FacebookAuth.i.login(
        permissions: ['public_profile', 'email'],
      );

      if (result.status == LoginStatus.cancelled) {
        throw AppException("sign_in_cancelled");
      }

      if (result.status == LoginStatus.failed) {
        throw AppException("facebook_login_failed");
      }

      // 2. الحصول على التوكن
      final AccessToken accessToken = result.accessToken!;

      // 3. إنشاء بيانات اعتماد لفايربيز
      final OAuthCredential credential = FacebookAuthProvider.credential(
        accessToken.tokenString,
      );

      // 4. تسجيل الدخول في فايربيز
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      return userCredential.user!;
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException("unknown_error");
    }
  }

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
