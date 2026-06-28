import 'package:singularity/core/usecases/usecase.dart';

import '../repositories/profile_repository.dart';

class IncrementWallpaperCount implements UseCase<void, String> {
  final ProfileRepository repository;
  IncrementWallpaperCount(this.repository);

  @override
  Future<void> call(String params) =>
      repository.incrementWallpaperCount(params);
}
