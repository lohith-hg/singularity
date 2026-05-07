import '../../../shared/entities/apod_entity.dart';
import '../../../cosmo_daily/data/datasources/apod_remote_datasource.dart';
import '../../domain/repositories/sky_stories_repository.dart';

class SkyStoriesRepositoryImpl implements SkyStoriesRepository {
  final ApodRemoteDataSource dataSource;
  SkyStoriesRepositoryImpl(this.dataSource);

  @override
  Future<List<ApodEntity>> getSkyStories() async {
    // Fetch 40 days back, starting from 10 days ago (gives a mix, not cutting-edge)
    final startDate = DateTime.now().subtract(const Duration(days: 10));
    final models = await dataSource.getApodPictures(
      startDate: startDate,
      daysBack: 40,
    );
    final stories = models.map((m) => m.toEntity()).toList()..shuffle();
    return stories;
  }
}
