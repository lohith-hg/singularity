import 'dart:convert';

import '../../../../core/constants/nasa_api.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/space_weather_event_model.dart';

abstract class DonkiRemoteDataSource {
  Future<List<SpaceWeatherEventModel>> getSpaceWeatherEvents({
    required String startDate,
    required String endDate,
  });
}

class DonkiRemoteDataSourceImpl implements DonkiRemoteDataSource {
  const DonkiRemoteDataSourceImpl({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<SpaceWeatherEventModel>> getSpaceWeatherEvents({
    required String startDate,
    required String endDate,
  }) async {
    final results = await Future.wait([
      _fetchEndpoint('CME', startDate, endDate, SpaceWeatherEventModel.fromCme),
      _fetchEndpoint('FLR', startDate, endDate, SpaceWeatherEventModel.fromFlr),
      _fetchEndpoint('GST', startDate, endDate, SpaceWeatherEventModel.fromGst),
      _fetchEndpoint('SEP', startDate, endDate, SpaceWeatherEventModel.fromSep),
    ]);

    final events = results.expand((list) => list).toList();
    if (events.isEmpty && results.every((list) => list.isEmpty)) {
      return events;
    }
    return events;
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
      final response = await _apiClient.get(uri, label: 'NASA DONKI $endpoint');
      final decoded = json.decode(response.body) as List? ?? [];
      return decoded.map((x) => mapper(x as Map<String, dynamic>)).toList();
    } on ServerException {
      return const [];
    } catch (_) {
      return const [];
    }
  }
}
