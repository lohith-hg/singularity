import '../../../../core/usecases/usecase.dart';
import '../entities/planet_entity.dart';
import '../repositories/explore_repository.dart';

class GetPlanets implements UseCase<List<PlanetEntity>, NoParams> {
  final ExploreRepository repository;
  GetPlanets(this.repository);

  @override
  Future<List<PlanetEntity>> call(NoParams params) {
    return repository.getPlanets();
  }
}
