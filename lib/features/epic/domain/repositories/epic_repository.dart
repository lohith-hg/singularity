import '../entities/epic_image_entity.dart';

abstract class EpicRepository {
  Future<List<EpicImageEntity>> getEpicImages();
}
