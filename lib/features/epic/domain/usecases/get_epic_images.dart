import '../../../../core/usecases/usecase.dart';
import '../entities/epic_image_entity.dart';
import '../repositories/epic_repository.dart';

class GetEpicImages implements UseCase<List<EpicImageEntity>, NoParams> {
  final EpicRepository repository;
  GetEpicImages(this.repository);

  @override
  Future<List<EpicImageEntity>> call(NoParams params) {
    return repository.getEpicImages();
  }
}
