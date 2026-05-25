import '../../../../core/constants/nasa_api.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/neo_model.dart';

abstract class NeoRemoteDataSource {
  Future<List<NeoModel>> getNeos({
    required String startDate,
    required String endDate,
  });
}

class NeoRemoteDataSourceImpl implements NeoRemoteDataSource {
  const NeoRemoteDataSourceImpl({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<NeoModel>> getNeos({
    required String startDate,
    required String endDate,
  }) async {
    final safeRange = _safeRange(startDate, endDate);
    final uri = Uri.https('api.nasa.gov', '/neo/rest/v1/feed', {
      'start_date': safeRange.$1,
      'end_date': safeRange.$2,
      'api_key': NasaApi.apiKey,
    });

    final response = await _apiClient.get(uri, label: 'NASA NeoWs');
    try {
      return neoListFromJson(response.body);
    } catch (_) {
      throw const ServerException(
        'NASA NeoWs returned data this app could not read.',
      );
    }
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
