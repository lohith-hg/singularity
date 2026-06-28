import '../../../../core/services/cached_resource.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/space_weather_event_entity.dart';
import '../repositories/donki_repository.dart';

class DonkiParams {
  final String startDate;
  final String endDate;
  const DonkiParams({required this.startDate, required this.endDate});
}

class GetSpaceWeatherEvents
    implements
        UseCase<CachedResource<List<SpaceWeatherEventEntity>>, DonkiParams> {
  final DonkiRepository repository;
  GetSpaceWeatherEvents(this.repository);

  @override
  Future<CachedResource<List<SpaceWeatherEventEntity>>> call(
    DonkiParams params,
  ) async =>
      repository.getSpaceWeatherEvents(
        startDate: params.startDate,
        endDate: params.endDate,
      );
}
