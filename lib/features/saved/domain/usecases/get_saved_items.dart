import '../entities/saved_item_entity.dart';
import '../repositories/saved_repository.dart';

class GetSavedItems {
  final SavedRepository _repo;
  GetSavedItems(this._repo);

  Future<List<SavedItemEntity>> call(String uid) => _repo.getSavedItems(uid);
}
