import '../../../../core/network/api_client.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/services/cached_resource.dart';
import '../models/rover_photo_model.dart';

abstract class MarsRoverRemoteDataSource {
  CachedResource<List<RoverPhotoModel>> getRoverPhotos({
    required String rover,
    required int page,
  });
}

class MarsRoverRemoteDataSourceImpl implements MarsRoverRemoteDataSource {
  MarsRoverRemoteDataSourceImpl({
    CacheService? cacheService,
    ApiClient apiClient = const ApiClient(),
  })  : _cache = cacheService,
        _apiClient = apiClient;

  final CacheService? _cache;
  final ApiClient _apiClient;

  static const _ttl = Duration(hours: 24);

  @override
  CachedResource<List<RoverPhotoModel>> getRoverPhotos({
    required String rover,
    required int page,
  }) {
    final uri = Uri.https('images-api.nasa.gov', '/search', {
      'q': '$rover rover mars',
      'media_type': 'image',
      'page': '$page',
      'page_size': '25',
    });

    Future<String> fetchBody() async =>
        (await _apiClient.get(uri, label: 'Mars Rover Photos')).body;

    final cache = _cache;
    if (cache == null) {
      return CachedResource(
        cached: null,
        isStale: true,
        refresh: () async => roverPhotoListFromJson(await fetchBody()),
      );
    }

    return cache.swr(
      key: 'mars_rover_${rover}_$page',
      ttl: _ttl,
      fetchBody: fetchBody,
      parse: roverPhotoListFromJson,
    );
  }
}
