import 'dart:convert';
import 'dart:math';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/history_album_model.dart';

abstract class NasaImagesRemoteDataSource {
  Future<List<HistoryAlbumModel>> getImagesByTopic(String topic);
  Future<List<HistoryAlbumModel>> searchImages(String query);
}

class NasaImagesRemoteDataSourceImpl implements NasaImagesRemoteDataSource {
  const NasaImagesRemoteDataSourceImpl({
    ApiClient apiClient = const ApiClient(),
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<HistoryAlbumModel>> getImagesByTopic(String topic) async {
    final page = Random().nextInt(10) + 1;
    final uri = Uri.https('images-api.nasa.gov', '/search', {
      'q': topic,
      'media_type': 'image',
      'page_size': '5',
      'page': '$page',
    });

    return _fetchImages(uri);
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
