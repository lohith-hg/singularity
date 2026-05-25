import '../entities/saved_item_entity.dart';
import '../../../shared/entities/apod_entity.dart';

abstract class SavedRepository {
  Future<List<SavedItemEntity>> getSavedItems(String uid);
  Future<void> saveApod(String uid, ApodEntity apod);
  Future<void> unsaveApod(String uid, String apodDate);
}
