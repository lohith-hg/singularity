import '../entities/space_weather_event_entity.dart';

abstract class DonkiRepository {
  Future<List<SpaceWeatherEventEntity>> getSpaceWeatherEvents({
    required String startDate,
    required String endDate,
  });
}
