import '../../domain/entities/nasa_image_entity.dart';
import '../../domain/repositories/nasa_images_repository.dart';
import '../datasources/nasa_images_remote_datasource.dart';

class NasaImagesRepositoryImpl implements NasaImagesRepository {
  final NasaImagesRemoteDataSource dataSource;
  NasaImagesRepositoryImpl(this.dataSource);

  @override
  Future<List<NasaImageEntity>> getImagesByTopic(String topic) async {
    final models = await dataSource.getImagesByTopic(topic);
    // Filter out items missing required fields (null-safe conversion)
    return models
        .map((m) => m.toEntity())
        .whereType<NasaImageEntity>()
        .toList();
  }
}
