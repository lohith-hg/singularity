import 'dart:convert';
import 'dart:math';

import '../../../../core/constants/topics.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/services/cached_resource.dart';
import '../models/history_album_model.dart';

abstract class NasaImagesRemoteDataSource {
  CachedResource<List<HistoryAlbumModel>> getVintageImages();
  Future<List<HistoryAlbumModel>> searchImages(String query);
}

class NasaImagesRemoteDataSourceImpl implements NasaImagesRemoteDataSource {
  NasaImagesRemoteDataSourceImpl({
    CacheService? cacheService,
    ApiClient apiClient = const ApiClient(),
  })  : _cache = cacheService,
        _apiClient = apiClient;

  final CacheService? _cache;
  final ApiClient _apiClient;

  static const _ttl = Duration(hours: 24);

  @override
  CachedResource<List<HistoryAlbumModel>> getVintageImages() {
    String encode(List<HistoryAlbumModel> list) =>
        jsonEncode(list.map((m) => m.toJson()).toList());

    List<HistoryAlbumModel> decode(String str) =>
        (jsonDecode(str) as List)
            .map((x) => HistoryAlbumModel.fromCached(x as Map<String, dynamic>))
            .toList();

    final cache = _cache;
    if (cache == null) {
      return CachedResource(
        cached: null,
        isStale: true,
        refresh: _fetchAllTopics,
      );
    }

    return cache.swrComposed(
      key: 'vintage_images',
      ttl: _ttl,
      fetch: _fetchAllTopics,
      encode: encode,
      decode: decode,
    );
  }

  @override
  Future<List<HistoryAlbumModel>> searchImages(String query) async {
    final uri = Uri.https('images-api.nasa.gov', '/search', {
      'q': query,
      'media_type': 'image',
      'page_size': '24',
    });
    return _fetchImages(uri);
  }

  Future<List<HistoryAlbumModel>> _fetchAllTopics() async {
    final shuffledTopics = List<String>.from(astronomyTopics)..shuffle(Random());
    final selectedTopics = shuffledTopics.take(8).toList();
    final results = await Future.wait(
      selectedTopics.map(_fetchByTopic),
    );
    return results.expand((list) => list).toList();
  }

  Future<List<HistoryAlbumModel>> _fetchByTopic(String topic) async {
    final page = Random().nextInt(10) + 1;
    final uri = Uri.https('images-api.nasa.gov', '/search', {
      'q': topic,
      'media_type': 'image',
      'page_size': '5',
      'page': '$page',
    });
    return _fetchImages(uri);
  }

  Future<List<HistoryAlbumModel>> _fetchImages(Uri uri) async {
    final response = await _apiClient.get(uri, label: 'NASA Image Library');
    try {
      final data = jsonDecode(response.body);
      final collection = data['collection'] as Map<String, dynamic>? ?? {};
      final items = collection['items'] as List<dynamic>? ?? [];
      return items
          .map(
            (item) => HistoryAlbumModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      throw const ServerException(
        'NASA Image Library returned data this app could not read.',
      );
    }
  }
}
