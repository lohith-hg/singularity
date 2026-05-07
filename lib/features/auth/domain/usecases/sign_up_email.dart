import 'package:singularity/features/auth/domain/entities/user_entity.dart';
import 'package:singularity/features/profile/domain/repositories/profile_repository.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailParams {
  final String name;
  final String email;
  final String password;
  const SignUpWithEmailParams(
      {required this.name, required this.email, required this.password});
}

// Orchestrates account creation + initial Firestore profile in one step.
class SignUpWithEmailUseCase {
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;

  SignUpWithEmailUseCase({
    required this.authRepository,
    required this.profileRepository,
  });

  Future<UserEntity> call(SignUpWithEmailParams params) async {
    final user = await authRepository.createUserWithEmailAndPassword(
      params.email,
      params.password,
    );
    final userWithProfile = UserEntity(
      id: user.id,
      name: params.name,
      email: user.email,
      bio: '📸 Exploring the universe, one shot at a time!',
      createdAt: DateTime.now(),
    );
    await profileRepository.createUserProfile(userWithProfile);
    return userWithProfile;
  }
}
