import '../../../../core/usecases/usecase.dart';
import '../entities/exoplanet_entity.dart';
import '../repositories/exoplanets_repository.dart';

class GetExoplanets implements UseCase<List<ExoplanetEntity>, NoParams> {
  final ExoplanetsRepository repository;
  GetExoplanets(this.repository);

  @override
  Future<List<ExoplanetEntity>> call(NoParams params) {
    return repository.getExoplanets();
  }
}
