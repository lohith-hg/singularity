import '../../../../core/constants/nasa_api.dart';
import '../../../../core/network/api_client.dart';
import '../models/apod_model.dart';

abstract class ApodRemoteDataSource {
  Future<List<ApodModel>> fetchApods({
    required DateTime startDate,
    required int daysBack,
  });
}

class ApodRemoteDataSourceImpl implements ApodRemoteDataSource {
  const ApodRemoteDataSourceImpl({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<ApodModel>> fetchApods({
    required DateTime startDate,
    required int daysBack,
  }) async {
    final latest = _safeLatestDate(startDate);
    final oldest = latest.subtract(Duration(days: daysBack));
    final uri = Uri.https('api.nasa.gov', '/planetary/apod', {
      'api_key': NasaApi.apiKey,
      'start_date': _fmt(oldest),
      'end_date': _fmt(latest),
      'thumbs': 'true',
    });
    final body = (await _apiClient.get(uri, label: 'NASA APOD')).body;
    return apodListFromJson(body);
  }

  DateTime _safeLatestDate(DateTime date) {
    final utc = date.toUtc();
    final safe = utc.hour < 12 ? utc.subtract(const Duration(days: 1)) : utc;
    return DateTime.utc(safe.year, safe.month, safe.day);
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
