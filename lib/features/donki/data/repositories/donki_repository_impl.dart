import '../../../../core/services/cached_resource.dart';
import '../../domain/entities/space_weather_event_entity.dart';
import '../../domain/repositories/donki_repository.dart';
import '../datasources/donki_remote_datasource.dart';

class DonkiRepositoryImpl implements DonkiRepository {
  final DonkiRemoteDataSource dataSource;
  DonkiRepositoryImpl(this.dataSource);

  @override
  CachedResource<List<SpaceWeatherEventEntity>> getSpaceWeatherEvents({
    required String startDate,
    required String endDate,
  }) =>
      dataSource
          .getSpaceWeatherEvents(startDate: startDate, endDate: endDate)
          .map((models) => models.map((m) => m.toEntity()).toList());
}
