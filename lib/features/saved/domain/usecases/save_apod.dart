import '../../../shared/entities/apod_entity.dart';
import '../repositories/saved_repository.dart';

class SaveApod {
  final SavedRepository _repo;
  SaveApod(this._repo);

  Future<void> call(ApodEntity apod) => _repo.saveApod(apod);
}
