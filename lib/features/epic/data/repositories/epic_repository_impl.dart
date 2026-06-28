import '../../../../core/services/cached_resource.dart';
import '../../domain/entities/epic_image_entity.dart';
import '../../domain/repositories/epic_repository.dart';
import '../datasources/epic_remote_datasource.dart';

class EpicRepositoryImpl implements EpicRepository {
  final EpicRemoteDataSource dataSource;
  EpicRepositoryImpl(this.dataSource);

  @override
  CachedResource<List<EpicImageEntity>> getEpicImages() =>
      dataSource
          .getEpicImages()
          .map((models) => models.map((m) => m.toEntity()).toList());
}
