import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/history_album_model.dart';

abstract class NasaImagesRemoteDataSource {
  Future<List<HistoryAlbumModel>> getImagesByTopic(String topic);
}

class NasaImagesRemoteDataSourceImpl implements NasaImagesRemoteDataSource {
  @override
  Future<List<HistoryAlbumModel>> getImagesByTopic(String topic) async {
    final page = Random().nextInt(10) + 1;
    final uri = Uri.parse(
      'https://images-api.nasa.gov/search'
      '?q=$topic&page_size=5&page=$page',
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['collection']['items'] as List<dynamic>;
      return items
          .map((item) => HistoryAlbumModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw ServerException('NASA Images API error: ${response.statusCode}');
  }
}
