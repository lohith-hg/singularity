import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:singularity/core/error/exceptions.dart';
import 'package:singularity/features/auth/data/models/user_model.dart';
import 'package:singularity/features/auth/domain/entities/user_entity.dart';

class GoogleSignInResult {
  final UserModel user;
  final bool isNewUser;
  GoogleSignInResult({required this.user, required this.isNewUser});
}

abstract class AuthRemoteDataSource {
  Stream<UserEntity?> get authStateChanges;
  UserEntity? get currentUser;
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> createUserWithEmailAndPassword(
    String email,
    String password,
  );
  Future<GoogleSignInResult> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn.instance;
  Future<void>? _googleSignInInitialization;

  Future<void> _ensureGoogleSignInInitialized() {
    return _googleSignInInitialization ??= _googleSignIn.initialize();
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel(id: user.uid, email: user.email);
    });
  }

  @override
  UserEntity? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return UserModel(id: user.uid, email: user.email);
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel(id: cred.user!.uid, email: cred.user!.email);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel(id: cred.user!.uid, email: cred.user!.email);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  @override
  Future<GoogleSignInResult> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      if (!_googleSignIn.supportsAuthenticate()) {
        throw const AuthException(
          'Google sign-in is not supported on this platform.',
        );
      }
      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final data = await _auth.signInWithCredential(credential);
      final user = UserModel(
        id: data.user!.uid,
        email: data.user!.email,
        name: googleUser.displayName,
      );
      return GoogleSignInResult(
        user: user,
        isNewUser: data.additionalUserInfo?.isNewUser ?? false,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException('Google sign-in was cancelled');
      }
      throw AuthException(e.description ?? 'Google sign-in failed');
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  AuthException _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return const AuthException(
          'The password provided is too weak.',
          code: 'weak-password',
        );
      case 'email-already-in-use':
        return const AuthException(
          'An account already exists for that email.',
          code: 'email-already-in-use',
        );
      case 'user-not-found':
        return const AuthException(
          'No user found for that email.',
          code: 'user-not-found',
        );
      case 'wrong-password':
        return const AuthException(
          'Incorrect password.',
          code: 'wrong-password',
        );
      case 'invalid-email':
        return const AuthException(
          'Invalid email address.',
          code: 'invalid-email',
        );
      default:
        return AuthException(
          e.message ?? 'Authentication failed',
          code: e.code,
        );
    }
  }
}
