import '../../../../core/services/cached_resource.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/epic_image_entity.dart';
import '../repositories/epic_repository.dart';

class GetEpicImages
    implements UseCase<CachedResource<List<EpicImageEntity>>, NoParams> {
  final EpicRepository repository;
  GetEpicImages(this.repository);

  @override
  Future<CachedResource<List<EpicImageEntity>>> call(NoParams params) async =>
      repository.getEpicImages();
}
