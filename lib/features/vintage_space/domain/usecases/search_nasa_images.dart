import '../../../../core/usecases/usecase.dart';
import '../entities/nasa_image_entity.dart';
import '../repositories/nasa_images_repository.dart';

class SearchNasaImages implements UseCase<List<NasaImageEntity>, String> {
  final NasaImagesRepository repository;
  SearchNasaImages(this.repository);

  @override
  Future<List<NasaImageEntity>> call(String params) {
    return repository.searchImages(params.trim());
  }
}
