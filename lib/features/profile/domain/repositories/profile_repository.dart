import 'package:singularity/features/auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity?> getUserProfile(String userId);
  Future<void> updateUserProfile(UserEntity user);
  Future<void> createUserProfile(UserEntity user);
  Future<void> incrementWallpaperCount(String userId);
}
