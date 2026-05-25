import '../../../shared/entities/apod_entity.dart';
import '../../domain/entities/saved_item_entity.dart';
import '../../domain/repositories/saved_repository.dart';
import '../datasources/saved_remote_datasource.dart';

class SavedRepositoryImpl implements SavedRepository {
  final SavedRemoteDataSource _dataSource;
  SavedRepositoryImpl(this._dataSource);

  @override
  Future<List<SavedItemEntity>> getSavedItems(String uid) =>
      _dataSource.getSavedItems(uid);

  @override
  Future<void> saveApod(String uid, ApodEntity apod) =>
      _dataSource.saveApod(uid, apod);

  @override
  Future<void> unsaveApod(String uid, String apodDate) =>
      _dataSource.unsaveApod(uid, apodDate);
}
