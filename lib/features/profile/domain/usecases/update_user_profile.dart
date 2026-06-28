import 'package:singularity/core/usecases/usecase.dart';
import 'package:singularity/features/auth/domain/entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfile implements UseCase<void, UserEntity> {
  final ProfileRepository repository;
  UpdateUserProfile(this.repository);

  @override
  Future<void> call(UserEntity params) => repository.updateUserProfile(params);
}
