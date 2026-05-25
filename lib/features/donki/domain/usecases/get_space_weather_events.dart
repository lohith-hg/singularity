import '../../../../core/usecases/usecase.dart';
import '../entities/space_weather_event_entity.dart';
import '../repositories/donki_repository.dart';

class DonkiParams {
  final String startDate;
  final String endDate;
  const DonkiParams({required this.startDate, required this.endDate});
}

class GetSpaceWeatherEvents
    implements UseCase<List<SpaceWeatherEventEntity>, DonkiParams> {
  final DonkiRepository repository;
  GetSpaceWeatherEvents(this.repository);

  @override
  Future<List<SpaceWeatherEventEntity>> call(DonkiParams params) {
    return repository.getSpaceWeatherEvents(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
