import '../../../../core/services/cached_resource.dart';
import '../entities/exoplanet_entity.dart';

abstract class ExoplanetsRepository {
  CachedResource<List<ExoplanetEntity>> getExoplanets();
}
