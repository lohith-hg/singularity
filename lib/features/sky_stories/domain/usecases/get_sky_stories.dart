import '../../../../core/usecases/usecase.dart';
import '../../../shared/entities/apod_entity.dart';
import '../repositories/sky_stories_repository.dart';

class GetSkyStories implements UseCase<List<ApodEntity>, NoParams> {
  final SkyStoriesRepository repository;
  GetSkyStories(this.repository);

  @override
  Future<List<ApodEntity>> call(NoParams params) {
    return repository.getSkyStories();
  }
}
