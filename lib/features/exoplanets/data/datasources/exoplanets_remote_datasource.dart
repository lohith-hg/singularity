import '../../../../core/network/api_client.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/services/cached_resource.dart';
import '../models/exoplanet_model.dart';

abstract class ExoplanetsRemoteDataSource {
  CachedResource<List<ExoplanetModel>> getExoplanets();
}

class ExoplanetsRemoteDataSourceImpl implements ExoplanetsRemoteDataSource {
  ExoplanetsRemoteDataSourceImpl({
    CacheService? cacheService,
    ApiClient apiClient = const ApiClient(),
  })  : _cache = cacheService,
        _apiClient = apiClient;

  final CacheService? _cache;
  final ApiClient _apiClient;

  static const _ttl = Duration(days: 7);

  @override
  CachedResource<List<ExoplanetModel>> getExoplanets() {
    const query =
        'select top 200 pl_name,pl_rade,pl_bmasse,pl_orbper,sy_dist,disc_year '
        'from ps where default_flag=1 order by disc_year desc';
    final uri = Uri.https('exoplanetarchive.ipac.caltech.edu', '/TAP/sync', {
      'query': query,
      'format': 'json',
    });

    Future<String> fetchBody() async =>
        (await _apiClient.get(uri, label: 'NASA Exoplanet Archive')).body;

    final cache = _cache;
    if (cache == null) {
      return CachedResource(
        cached: null,
        isStale: true,
        refresh: () async => exoplanetListFromJson(await fetchBody()),
      );
    }

    return cache.swr(
      key: 'exoplanets_top200',
      ttl: _ttl,
      fetchBody: fetchBody,
      parse: exoplanetListFromJson,
    );
  }
}
