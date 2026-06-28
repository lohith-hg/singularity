import '../../../shared/entities/apod_entity.dart';
import '../repositories/apod_repository.dart';

class GetApodPictures {
  GetApodPictures(this._repo);
  final ApodRepository _repo;

  ({List<ApodEntity> apods, bool isStale}) call() =>
      (apods: _repo.getStoredApods(), isStale: _repo.isStale);
}
