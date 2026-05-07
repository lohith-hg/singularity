import '../../../shared/entities/apod_entity.dart';

abstract class ApodRepository {
  Future<List<ApodEntity>> getApodPictures({
    required DateTime startDate,
    required int daysBack,
  });
}
