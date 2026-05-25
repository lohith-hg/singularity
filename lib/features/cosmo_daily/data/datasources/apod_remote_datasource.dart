import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/nasa_api.dart';
import '../../../../core/network/api_client.dart';
import '../models/apod_model.dart';

abstract class ApodRemoteDataSource {
  Future<List<ApodModel>> getApodPictures({
    required DateTime startDate,
    required int daysBack,
  });
}

class ApodRemoteDataSourceImpl implements ApodRemoteDataSource {
  const ApodRemoteDataSourceImpl({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<ApodModel>> getApodPictures({
    required DateTime startDate,
    required int daysBack,
  }) async {
    final latestDate = _safeLatestDate(startDate);
    final oldestDate = latestDate.subtract(Duration(days: daysBack));

    final uri = Uri.https('api.nasa.gov', '/planetary/apod', {
      'api_key': NasaApi.apiKey,
      'start_date': _formatDate(oldestDate),
      'end_date': _formatDate(latestDate),
      'thumbs': 'true',
    });

    final response = await _apiClient.get(uri, label: 'NASA APOD');
    try {
      return apodListFromJson(response.body);
    } catch (_) {
      throw const ServerException(
        'NASA APOD returned data this app could not read.',
      );
    }
  }

  DateTime _safeLatestDate(DateTime date) {
    final utc = date.toUtc();
    final safe = utc.hour < 12 ? utc.subtract(const Duration(days: 1)) : utc;
    return DateTime.utc(safe.year, safe.month, safe.day);
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
