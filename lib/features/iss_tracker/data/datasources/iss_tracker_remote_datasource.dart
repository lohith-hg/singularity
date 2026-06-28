import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/iss_position_model.dart';

abstract class IssTrackerRemoteDataSource {
  Future<IssPositionModel> getIssPosition();
}

class IssTrackerRemoteDataSourceImpl implements IssTrackerRemoteDataSource {
  const IssTrackerRemoteDataSourceImpl({
    ApiClient apiClient = const ApiClient(),
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<IssPositionModel> getIssPosition() async {
    final uri = Uri.parse('https://api.wheretheiss.at/v1/satellites/25544');

    final response = await _apiClient.get(uri, label: 'ISS position');
    try {
      return issPositionFromJson(response.body);
    } catch (_) {
      throw const ServerException(
        'ISS position returned data this app could not read.',
      );
    }
  }
}
