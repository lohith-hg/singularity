import '../../../../core/services/cached_resource.dart';
import '../entities/nasa_image_entity.dart';

abstract class NasaImagesRepository {
  CachedResource<List<NasaImageEntity>> getVintageImages();
  Future<List<NasaImageEntity>> searchImages(String query);
}
