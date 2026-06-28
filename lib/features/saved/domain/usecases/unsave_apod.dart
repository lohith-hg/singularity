import '../repositories/saved_repository.dart';

class UnsaveApod {
  final SavedRepository _repo;
  UnsaveApod(this._repo);

  Future<void> call(String apodDate) => _repo.unsaveApod(apodDate);
}
