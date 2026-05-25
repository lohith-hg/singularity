import '../../domain/entities/epic_image_entity.dart';
import '../../domain/repositories/epic_repository.dart';
import '../datasources/epic_remote_datasource.dart';

class EpicRepositoryImpl implements EpicRepository {
  final EpicRemoteDataSource dataSource;
  EpicRepositoryImpl(this.dataSource);

  @override
  Future<List<EpicImageEntity>> getEpicImages() async {
    final models = await dataSource.getEpicImages();
    return models.map((m) => m.toEntity()).toList();
  }
}
