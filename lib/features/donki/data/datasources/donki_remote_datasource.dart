import 'dart:convert';

import '../../../../core/constants/nasa_api.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/services/cached_resource.dart';
import '../models/space_weather_event_model.dart';

abstract class DonkiRemoteDataSource {
  CachedResource<List<SpaceWeatherEventModel>> getSpaceWeatherEvents({
    required String startDate,
    required String endDate,
  });
}

class DonkiRemoteDataSourceImpl implements DonkiRemoteDataSource {
  DonkiRemoteDataSourceImpl({
    CacheService? cacheService,
    ApiClient apiClient = const ApiClient(),
  })  : _cache = cacheService,
        _apiClient = apiClient;

  final CacheService? _cache;
  final ApiClient _apiClient;

  static const _ttl = Duration(hours: 12);

  @override
  CachedResource<List<SpaceWeatherEventModel>> getSpaceWeatherEvents({
    required String startDate,
    required String endDate,
  }) {
    Future<List<SpaceWeatherEventModel>> fetch() =>
        _fetchAll(startDate, endDate);

    final cache = _cache;
    if (cache == null) {
      return CachedResource(
        cached: null,
        isStale: true,
        refresh: fetch,
      );
    }

    return cache.swrComposed(
      key: 'donki_7d',
      ttl: _ttl,
      fetch: fetch,
      encode: spaceWeatherEventListToJson,
      decode: spaceWeatherEventListFromCached,
    );
  }

  Future<List<SpaceWeatherEventModel>> _fetchAll(
    String startDate,
    String endDate,
  ) async {
    final results = await Future.wait([
      _fetchEndpoint('CME', startDate, endDate, SpaceWeatherEventModel.fromCme),
      _fetchEndpoint('FLR', startDate, endDate, SpaceWeatherEventModel.fromFlr),
      _fetchEndpoint('GST', startDate, endDate, SpaceWeatherEventModel.fromGst),
      _fetchEndpoint('SEP', startDate, endDate, SpaceWeatherEventModel.fromSep),
    ]);
    return results.expand((list) => list).toList();
  }

  Future<List<SpaceWeatherEventModel>> _fetchEndpoint(
    String endpoint,
    String startDate,
    String endDate,
    SpaceWeatherEventModel Function(Map<String, dynamic>) mapper,
  ) async {
    final uri = Uri.https('api.nasa.gov', '/DONKI/$endpoint', {
      'startDate': startDate,
      'endDate': endDate,
      'api_key': NasaApi.apiKey,
    });

    try {
      final response =
          await _apiClient.get(uri, label: 'NASA DONKI $endpoint');
      final decoded = json.decode(response.body) as List? ?? [];
      return decoded
          .map((x) => mapper(x as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
