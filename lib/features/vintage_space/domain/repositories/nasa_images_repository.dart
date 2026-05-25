import '../entities/nasa_image_entity.dart';

abstract class NasaImagesRepository {
  Future<List<NasaImageEntity>> getImagesByTopic(String topic);
  Future<List<NasaImageEntity>> searchImages(String query);
}
