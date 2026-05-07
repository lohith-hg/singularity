import 'package:singularity/features/auth/domain/entities/user_entity.dart';
import 'package:singularity/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:singularity/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource dataSource;
  ProfileRepositoryImpl(this.dataSource);

  @override
  Future<UserEntity?> getUserProfile(String userId) =>
      dataSource.getUserProfile(userId);

  @override
  Future<void> updateUserProfile(UserEntity user) =>
      dataSource.updateUserProfile(user);

  @override
  Future<void> createUserProfile(UserEntity user) =>
      dataSource.createUserProfile(user);
}
