import '../../../shared/entities/apod_entity.dart';
import '../repositories/apod_repository.dart';

class FetchApodRange {
  FetchApodRange(this._repo);
  final ApodRepository _repo;

  Future<List<ApodEntity>> fetchInitial() => _repo.fetchInitial();
  Future<void> fetchBackground() => _repo.fetchBackground();
}
