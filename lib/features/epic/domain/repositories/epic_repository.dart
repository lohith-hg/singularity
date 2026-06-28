import '../../../../core/services/cached_resource.dart';
import '../entities/epic_image_entity.dart';

abstract class EpicRepository {
  CachedResource<List<EpicImageEntity>> getEpicImages();
}
