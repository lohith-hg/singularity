import '../../../../core/services/cached_resource.dart';
import '../entities/space_weather_event_entity.dart';

abstract class DonkiRepository {
  CachedResource<List<SpaceWeatherEventEntity>> getSpaceWeatherEvents({
    required String startDate,
    required String endDate,
  });
}
