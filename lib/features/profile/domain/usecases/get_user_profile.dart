import 'package:singularity/core/usecases/usecase.dart';
import 'package:singularity/features/auth/domain/entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class GetUserProfile implements UseCase<UserEntity?, String> {
  final ProfileRepository repository;
  GetUserProfile(this.repository);

  @override
  Future<UserEntity?> call(String params) => repository.getUserProfile(params);
}
