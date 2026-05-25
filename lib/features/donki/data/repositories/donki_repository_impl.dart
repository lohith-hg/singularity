import '../../domain/entities/space_weather_event_entity.dart';
import '../../domain/repositories/donki_repository.dart';
import '../datasources/donki_remote_datasource.dart';

class DonkiRepositoryImpl implements DonkiRepository {
  final DonkiRemoteDataSource dataSource;
  DonkiRepositoryImpl(this.dataSource);

  @override
  Future<List<SpaceWeatherEventEntity>> getSpaceWeatherEvents({
    required String startDate,
    required String endDate,
  }) async {
    final models = await dataSource.getSpaceWeatherEvents(
      startDate: startDate,
      endDate: endDate,
    );
    return models.map((m) => m.toEntity()).toList();
  }
}
