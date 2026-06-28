import '../../../shared/entities/apod_entity.dart';

abstract class ApodRepository {
  List<ApodEntity> getStoredApods();
  bool get isStale;

  /// Fetches [daysBack] days ending at [startDate], merges into local store,
  /// returns the full updated local list sorted newest-first.
  Future<List<ApodEntity>> fetchInitial();

  /// Fetches the 25 days prior to the initial window and merges into store.
  /// Marks the store as freshly filled on success.
  Future<void> fetchBackground();
}
