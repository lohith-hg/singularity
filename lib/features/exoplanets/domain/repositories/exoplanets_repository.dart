import '../entities/exoplanet_entity.dart';

abstract class ExoplanetsRepository {
  Future<List<ExoplanetEntity>> getExoplanets();
}
