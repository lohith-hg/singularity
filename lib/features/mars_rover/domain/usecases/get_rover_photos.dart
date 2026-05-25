import '../../../../core/usecases/usecase.dart';
import '../entities/rover_photo_entity.dart';
import '../repositories/mars_rover_repository.dart';

class RoverParams {
  final String rover;
  final int page;
  const RoverParams({required this.rover, this.page = 1});
}

class GetRoverPhotos implements UseCase<List<RoverPhotoEntity>, RoverParams> {
  final MarsRoverRepository repository;
  GetRoverPhotos(this.repository);

  @override
  Future<List<RoverPhotoEntity>> call(RoverParams params) {
    return repository.getRoverPhotos(rover: params.rover, page: params.page);
  }
}
