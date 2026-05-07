import '../../../shared/entities/apod_entity.dart';

abstract class SkyStoriesRepository {
  Future<List<ApodEntity>> getSkyStories();
}
