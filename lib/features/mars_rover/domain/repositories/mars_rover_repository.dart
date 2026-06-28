import '../../../../core/services/cached_resource.dart';
import '../entities/rover_photo_entity.dart';

abstract class MarsRoverRepository {
  CachedResource<List<RoverPhotoEntity>> getRoverPhotos({
    required String rover,
    required int page,
  });
}
