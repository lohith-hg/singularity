import '../../../../core/services/cached_resource.dart';
import '../../domain/entities/exoplanet_entity.dart';
import '../../domain/repositories/exoplanets_repository.dart';
import '../datasources/exoplanets_remote_datasource.dart';

class ExoplanetsRepositoryImpl implements ExoplanetsRepository {
  final ExoplanetsRemoteDataSource dataSource;
  ExoplanetsRepositoryImpl(this.dataSource);

  @override
  CachedResource<List<ExoplanetEntity>> getExoplanets() =>
      dataSource
          .getExoplanets()
          .map((models) => models.map((m) => m.toEntity()).toList());
}
