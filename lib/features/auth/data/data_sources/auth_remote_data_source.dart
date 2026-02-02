import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/errors/exceptions.dart';

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
      throw AuthException(
        message: e.message ?? "Failed to login",
        code: e.code,
      );
    } on Exception catch (e) {
      throw ServerException("$e");
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
      throw AuthException(
        message: e.message ?? "Failed to sign up",
        code: e.code,
      );
    } on Exception catch (e) {
      throw ServerException("$e");
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

      return userCredential.user!;
    } on GoogleSignInException catch (e) {
      throw AuthException(
        message: e.description ?? "Failed to login with google",
        code: e.code.name,
      );
    } on Exception catch (e) {
      throw ServerException("$e");
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on Exception catch (e) {
      ServerException(e.toString());
    }
  }

  @override
  Stream<User?> get userStream => _firebaseAuth.authStateChanges();

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: e.message ?? "Failed to reset password",
        code: e.code,
      );
    } on Exception catch (e) {
      ServerException("$e");
    }
  }
}
