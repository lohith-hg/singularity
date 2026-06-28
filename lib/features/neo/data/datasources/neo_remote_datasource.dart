import '../../../../core/constants/nasa_api.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/services/cached_resource.dart';
import '../models/neo_model.dart';

abstract class NeoRemoteDataSource {
  CachedResource<List<NeoModel>> getNeos({
    required String startDate,
    required String endDate,
  });
}

class NeoRemoteDataSourceImpl implements NeoRemoteDataSource {
  NeoRemoteDataSourceImpl({
    CacheService? cacheService,
    ApiClient apiClient = const ApiClient(),
  })  : _cache = cacheService,
        _apiClient = apiClient;

  final CacheService? _cache;
  final ApiClient _apiClient;

  static const _ttl = Duration(hours: 12);

  @override
  CachedResource<List<NeoModel>> getNeos({
    required String startDate,
    required String endDate,
  }) {
    final safeRange = _safeRange(startDate, endDate);
    final uri = Uri.https('api.nasa.gov', '/neo/rest/v1/feed', {
      'start_date': safeRange.$1,
      'end_date': safeRange.$2,
      'api_key': NasaApi.apiKey,
    });

    Future<String> fetchBody() async =>
        (await _apiClient.get(uri, label: 'NASA NeoWs')).body;

    final cache = _cache;
    if (cache == null) {
      return CachedResource(
        cached: null,
        isStale: true,
        refresh: () async => neoListFromJson(await fetchBody()),
      );
    }

    // Key includes the week's start date so different weeks don't share cache.
    return cache.swr(
      key: 'neo_${safeRange.$1}',
      ttl: _ttl,
      fetchBody: fetchBody,
      parse: neoListFromJson,
    );
  }

  (String, String) _safeRange(String startDate, String endDate) {
    final start = DateTime.tryParse(startDate);
    final end = DateTime.tryParse(endDate);
    if (start == null || end == null) return (startDate, endDate);

    final safeEnd = end.difference(start).inDays > 7
        ? start.add(const Duration(days: 7))
        : end;
    return (_formatDate(start), _formatDate(safeEnd));
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
