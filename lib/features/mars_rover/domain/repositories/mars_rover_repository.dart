import '../entities/rover_photo_entity.dart';

abstract class MarsRoverRepository {
  Future<List<RoverPhotoEntity>> getRoverPhotos({
    required String rover,
    required int page,
  });
}
