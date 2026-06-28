import '../../../../core/constants/nasa_api.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/services/cached_resource.dart';
import '../models/epic_image_model.dart';

abstract class EpicRemoteDataSource {
  CachedResource<List<EpicImageModel>> getEpicImages();
}

class EpicRemoteDataSourceImpl implements EpicRemoteDataSource {
  EpicRemoteDataSourceImpl({
    CacheService? cacheService,
    ApiClient apiClient = const ApiClient(),
  })  : _cache = cacheService,
        _apiClient = apiClient;

  final CacheService? _cache;
  final ApiClient _apiClient;

  static const _ttl = Duration(hours: 12);

  @override
  CachedResource<List<EpicImageModel>> getEpicImages() {
    final cache = _cache;
    if (cache == null) {
      return CachedResource(
        cached: null,
        isStale: true,
        refresh: () async => epicImageListFromJson(await _fetchBody()),
      );
    }
    return cache.swr(
      key: 'epic_latest',
      ttl: _ttl,
      fetchBody: _fetchBody,
      parse: epicImageListFromJson,
    );
  }

  // Tries the /images endpoint first; falls back to the date-specific endpoint.
  // Returns the winning raw JSON body string (not parsed) so swr can cache it.
  Future<String> _fetchBody() async {
    try {
      final uri = Uri.https('api.nasa.gov', '/EPIC/api/natural/images', {
        'api_key': NasaApi.apiKey,
      });
      final response = await _apiClient.get(uri, label: 'NASA EPIC');
      return response.body;
    } on ServerException {
      return _fetchMostRecentDateBody();
    }
  }

  Future<String> _fetchMostRecentDateBody() async {
    final allUri = Uri.https('api.nasa.gov', '/EPIC/api/natural/all', {
      'api_key': NasaApi.apiKey,
    });
    final allResponse =
        await _apiClient.get(allUri, label: 'NASA EPIC dates');

    late String mostRecentDate;
    try {
      final dates = epicDatesFromJson(allResponse.body);
      if (dates.isEmpty) {
        throw const ServerException('No EPIC images are available.');
      }
      mostRecentDate = dates.last;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('NASA EPIC returned unexpected date data.');
    }

    final dateUri = Uri.https(
      'api.nasa.gov',
      '/EPIC/api/natural/date/$mostRecentDate',
      {'api_key': NasaApi.apiKey},
    );
    final dateResponse =
        await _apiClient.get(dateUri, label: 'NASA EPIC');
    return dateResponse.body;
  }
}
