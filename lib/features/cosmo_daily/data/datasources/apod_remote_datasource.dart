import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/apod_model.dart';

abstract class ApodRemoteDataSource {
  Future<List<ApodModel>> getApodPictures({
    required DateTime startDate,
    required int daysBack,
  });
}

class ApodRemoteDataSourceImpl implements ApodRemoteDataSource {
  static const _apiKey = 'Ah79iXNawQ4pH4Yl9j29zLaf8fBMabbE1dB6GtvW';

  @override
  Future<List<ApodModel>> getApodPictures({
    required DateTime startDate,
    required int daysBack,
  }) async {
    // Subtract 9 hours to avoid getting "today" before NASA publishes it
    final latestDate = startDate.subtract(const Duration(hours: 9));
    final oldestDate = startDate.subtract(Duration(days: daysBack));

    final uri = Uri.parse(
      'https://api.nasa.gov/planetary/apod'
      '?api_key=$_apiKey'
      '&start_date=${_formatDate(oldestDate)}'
      '&end_date=${_formatDate(latestDate)}',
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return apodListFromJson(response.body);
    }
    throw ServerException('NASA APOD API error: ${response.statusCode}');
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
