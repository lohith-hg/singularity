import 'package:singularity/features/auth/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;
  SignInWithGoogleUseCase(this.repository);

  Future<UserEntity> call() => repository.signInWithGoogle();
}
