import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/cache_service.dart';
import '../models/rover_photo_model.dart';

abstract class MarsRoverRemoteDataSource {
  Future<List<RoverPhotoModel>> getRoverPhotos({
    required String rover,
    required int page,
  });
}

class MarsRoverRemoteDataSourceImpl implements MarsRoverRemoteDataSource {
  MarsRoverRemoteDataSourceImpl({
    CacheService? cacheService,
    ApiClient apiClient = const ApiClient(),
  }) : _cache = cacheService,
       _apiClient = apiClient;

  final CacheService? _cache;
  final ApiClient _apiClient;

  static const _ttl = Duration(hours: 24);

  @override
  Future<List<RoverPhotoModel>> getRoverPhotos({
    required String rover,
    required int page,
  }) async {
    final cacheKey = 'mars_rover_${rover}_$page';

    // Cache hit — no network call
    if (_cache != null) {
      final cached = _cache.get(cacheKey, ttl: _ttl);
      if (cached != null) {
        try {
          return roverPhotoListFromJson(cached);
        } catch (_) {
          // Corrupted cache entry — fall through to network
          await _cache.invalidate(cacheKey);
        }
      }
    }

    // Network fetch
    final uri = Uri.https('images-api.nasa.gov', '/search', {
      'q': '$rover rover mars',
      'media_type': 'image',
      'page': '$page',
      'page_size': '25',
    });
    final response = await _apiClient.get(uri, label: 'Mars Rover Photos');

    // Persist to cache before parsing
    await _cache?.set(cacheKey, response.body);

    try {
      return roverPhotoListFromJson(response.body);
    } catch (_) {
      throw const ServerException(
        'Mars Rover Photos returned data this app could not read.',
      );
    }
  }
}
