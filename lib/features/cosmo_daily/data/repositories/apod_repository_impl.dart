import '../../../shared/entities/apod_entity.dart';
import '../../domain/repositories/apod_repository.dart';
import '../datasources/apod_local_datasource.dart';
import '../datasources/apod_remote_datasource.dart';

class ApodRepositoryImpl implements ApodRepository {
  ApodRepositoryImpl({
    required ApodLocalDataSource local,
    required ApodRemoteDataSource remote,
  }) : _local = local,
       _remote = remote;

  final ApodLocalDataSource _local;
  final ApodRemoteDataSource _remote;

  static const _initialDays = 10;
  static const _backgroundDays = 25;

  @override
  List<ApodEntity> getStoredApods() => _local.getStoredApods();

  @override
  bool get isStale => _local.isStale;

  @override
  Future<List<ApodEntity>> fetchInitial() async {
    final models = await _remote.fetchApods(
      startDate: DateTime.now(),
      daysBack: _initialDays,
    );
    await _local.mergeApods(models.map((m) => m.toEntity()).toList());
    return _local.getStoredApods();
  }

  @override
  Future<void> fetchBackground() async {
    // Shift the window back by _initialDays to get the next batch.
    final offset = DateTime.now().subtract(const Duration(days: _initialDays));
    final models = await _remote.fetchApods(
      startDate: offset,
      daysBack: _backgroundDays,
    );
    await _local.mergeApods(models.map((m) => m.toEntity()).toList());
    await _local.markFilled();
  }
}
