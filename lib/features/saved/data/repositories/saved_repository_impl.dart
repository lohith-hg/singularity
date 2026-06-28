import '../../../shared/entities/apod_entity.dart';
import '../../domain/entities/saved_item_entity.dart';
import '../../domain/repositories/saved_repository.dart';
import '../datasources/saved_remote_datasource.dart';

class SavedRepositoryImpl implements SavedRepository {
  final SavedLocalDataSource _dataSource;
  SavedRepositoryImpl(this._dataSource);

  @override
  Future<List<SavedItemEntity>> getSavedItems() => _dataSource.getSavedItems();

  @override
  Future<void> saveApod(ApodEntity apod) => _dataSource.saveApod(apod);

  @override
  Future<void> unsaveApod(String apodDate) => _dataSource.unsaveApod(apodDate);
}
