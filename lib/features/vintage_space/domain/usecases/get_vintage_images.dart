import '../../../../core/services/cached_resource.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/nasa_image_entity.dart';
import '../repositories/nasa_images_repository.dart';

class GetVintageImages
    implements UseCase<CachedResource<List<NasaImageEntity>>, NoParams> {
  final NasaImagesRepository repository;
  GetVintageImages(this.repository);

  @override
  Future<CachedResource<List<NasaImageEntity>>> call(NoParams params) async =>
      repository.getVintageImages();
}
