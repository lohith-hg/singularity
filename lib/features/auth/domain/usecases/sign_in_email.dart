import 'package:singularity/features/auth/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailParams {
  final String email;
  final String password;
  const SignInWithEmailParams({required this.email, required this.password});
}

class SignInWithEmailUseCase {
  final AuthRepository repository;
  SignInWithEmailUseCase(this.repository);

  Future<UserEntity> call(SignInWithEmailParams params) =>
      repository.signInWithEmailAndPassword(params.email, params.password);
}
