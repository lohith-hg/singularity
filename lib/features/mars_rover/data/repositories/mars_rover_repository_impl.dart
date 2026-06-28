import '../../../../core/services/cached_resource.dart';
import '../../domain/entities/rover_photo_entity.dart';
import '../../domain/repositories/mars_rover_repository.dart';
import '../datasources/mars_rover_remote_datasource.dart';

class MarsRoverRepositoryImpl implements MarsRoverRepository {
  final MarsRoverRemoteDataSource dataSource;
  MarsRoverRepositoryImpl(this.dataSource);

  @override
  CachedResource<List<RoverPhotoEntity>> getRoverPhotos({
    required String rover,
    required int page,
  }) =>
      dataSource
          .getRoverPhotos(rover: rover, page: page)
          .map((models) => models.map((m) => m.toEntity()).toList());
}
