import '../../domain/entities/nasa_image_entity.dart';
import '../../domain/repositories/nasa_images_repository.dart';
import '../datasources/nasa_images_remote_datasource.dart';
import '../models/history_album_model.dart';

class NasaImagesRepositoryImpl implements NasaImagesRepository {
  final NasaImagesRemoteDataSource dataSource;
  NasaImagesRepositoryImpl(this.dataSource);

  @override
  Future<List<NasaImageEntity>> getImagesByTopic(String topic) async {
    final models = await dataSource.getImagesByTopic(topic);
    return _toEntities(models);
  }

  @override
  Future<List<NasaImageEntity>> searchImages(String query) async {
    final models = await dataSource.searchImages(query);
    return _toEntities(models);
  }

  List<NasaImageEntity> _toEntities(List<HistoryAlbumModel> models) {
    // Filter out items missing required fields (null-safe conversion)
    return models
        .map((m) => m.toEntity())
        .whereType<NasaImageEntity>()
        .toList();
  }
}
