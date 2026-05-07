import 'package:singularity/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:singularity/features/auth/domain/entities/user_entity.dart';
import 'package:singularity/features/auth/domain/repositories/auth_repository.dart';
import 'package:singularity/features/profile/domain/repositories/profile_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;
  final ProfileRepository profileRepository;

  AuthRepositoryImpl({
    required this.dataSource,
    required this.profileRepository,
  });

  @override
  Stream<UserEntity?> get authStateChanges => dataSource.authStateChanges;

  @override
  UserEntity? get currentUser => dataSource.currentUser;

  @override
  Future<UserEntity> signInWithEmailAndPassword(
          String email, String password) =>
      dataSource.signInWithEmailAndPassword(email, password);

  @override
  Future<UserEntity> createUserWithEmailAndPassword(
          String email, String password) =>
      dataSource.createUserWithEmailAndPassword(email, password);

  @override
  Future<UserEntity> signInWithGoogle() async {
    final result = await dataSource.signInWithGoogle();
    if (result.isNewUser) {
      final newUserWithProfile = UserEntity(
        id: result.user.id,
        name: result.user.name,
        email: result.user.email,
        bio: '📸 Exploring the universe, one shot at a time!',
        createdAt: DateTime.now(),
      );
      await profileRepository.createUserProfile(newUserWithProfile);
      return newUserWithProfile;
    }
    return result.user;
  }

  @override
  Future<void> signOut() => dataSource.signOut();

  @override
  Future<void> resetPassword(String email) =>
      dataSource.resetPassword(email);
}
