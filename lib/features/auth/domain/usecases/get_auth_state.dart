import 'package:singularity/core/usecases/usecase.dart';
import 'package:singularity/features/auth/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

// Returns a stream instead of a Future; not covered by UseCase<T,P> base class.
class GetAuthState {
  final AuthRepository repository;
  GetAuthState(this.repository);

  Stream<UserEntity?> call(NoParams params) => repository.authStateChanges;
}
