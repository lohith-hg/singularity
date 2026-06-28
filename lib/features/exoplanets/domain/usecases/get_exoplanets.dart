import '../../../../core/services/cached_resource.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/exoplanet_entity.dart';
import '../repositories/exoplanets_repository.dart';

class GetExoplanets
    implements UseCase<CachedResource<List<ExoplanetEntity>>, NoParams> {
  final ExoplanetsRepository repository;
  GetExoplanets(this.repository);

  @override
  Future<CachedResource<List<ExoplanetEntity>>> call(NoParams params) async =>
      repository.getExoplanets();
}
