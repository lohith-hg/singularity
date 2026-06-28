import '../entities/saved_item_entity.dart';
import '../../../shared/entities/apod_entity.dart';

abstract class SavedRepository {
  Future<List<SavedItemEntity>> getSavedItems();
  Future<void> saveApod(ApodEntity apod);
  Future<void> unsaveApod(String apodDate);
}
