import '../../../shared/entities/apod_entity.dart';
import '../../domain/repositories/apod_repository.dart';
import '../datasources/apod_remote_datasource.dart';

class ApodRepositoryImpl implements ApodRepository {
  final ApodRemoteDataSource dataSource;
  ApodRepositoryImpl(this.dataSource);

  @override
  Future<List<ApodEntity>> getApodPictures({
    required DateTime startDate,
    required int daysBack,
  }) async {
    final models = await dataSource.getApodPictures(
      startDate: startDate,
      daysBack: daysBack,
    );
    return models.map((m) => m.toEntity()).toList();
  }
}
