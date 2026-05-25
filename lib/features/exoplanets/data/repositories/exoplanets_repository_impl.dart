import '../../domain/entities/exoplanet_entity.dart';
import '../../domain/repositories/exoplanets_repository.dart';
import '../datasources/exoplanets_remote_datasource.dart';

class ExoplanetsRepositoryImpl implements ExoplanetsRepository {
  final ExoplanetsRemoteDataSource dataSource;
  ExoplanetsRepositoryImpl(this.dataSource);

  @override
  Future<List<ExoplanetEntity>> getExoplanets() async {
    final models = await dataSource.getExoplanets();
    return models.map((m) => m.toEntity()).toList();
  }
}
