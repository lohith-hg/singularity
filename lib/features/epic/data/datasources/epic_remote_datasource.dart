import '../../../../core/constants/nasa_api.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/epic_image_model.dart';

abstract class EpicRemoteDataSource {
  Future<List<EpicImageModel>> getEpicImages();
}

class EpicRemoteDataSourceImpl implements EpicRemoteDataSource {
  const EpicRemoteDataSourceImpl({ApiClient apiClient = const ApiClient()})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<EpicImageModel>> getEpicImages() async {
    // The /images endpoint returns 404 when no images exist for the current
    // day. Fall back to the most recent available date from /all.
    try {
      final uri = Uri.https('api.nasa.gov', '/EPIC/api/natural/images', {
        'api_key': NasaApi.apiKey,
      });
      final response = await _apiClient.get(uri, label: 'NASA EPIC');
      return epicImageListFromJson(response.body);
    } on ServerException {
      return _fetchMostRecentDate();
    } catch (_) {
      return _fetchMostRecentDate();
    }
  }

  Future<List<EpicImageModel>> _fetchMostRecentDate() async {
    final allUri = Uri.https('api.nasa.gov', '/EPIC/api/natural/all', {
      'api_key': NasaApi.apiKey,
    });
    final allResponse = await _apiClient.get(allUri, label: 'NASA EPIC dates');
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
    final dateResponse = await _apiClient.get(dateUri, label: 'NASA EPIC');
    try {
      return epicImageListFromJson(dateResponse.body);
    } catch (_) {
      throw const ServerException(
        'NASA EPIC returned data this app could not read.',
      );
    }
  }
}
