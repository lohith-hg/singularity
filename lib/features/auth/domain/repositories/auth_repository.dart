import 'package:singularity/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  UserEntity? get currentUser;
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity> createUserWithEmailAndPassword(
    String email,
    String password,
  );
  Future<UserEntity> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}
