import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/exoplanet_model.dart';

abstract class ExoplanetsRemoteDataSource {
  Future<List<ExoplanetModel>> getExoplanets();
}

class ExoplanetsRemoteDataSourceImpl implements ExoplanetsRemoteDataSource {
  const ExoplanetsRemoteDataSourceImpl({
    ApiClient apiClient = const ApiClient(),
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<ExoplanetModel>> getExoplanets() async {
    const query =
        'select top 200 pl_name,pl_rade,pl_bmasse,pl_orbper,sy_dist,disc_year '
        'from ps where default_flag=1 order by disc_year desc';
    final uri = Uri.https('exoplanetarchive.ipac.caltech.edu', '/TAP/sync', {
      'query': query,
      'format': 'json',
    });

    final response = await _apiClient.get(uri, label: 'NASA Exoplanet Archive');
    try {
      return exoplanetListFromJson(response.body);
    } catch (_) {
      throw const ServerException(
        'NASA Exoplanet Archive returned data this app could not read.',
      );
    }
  }
}
