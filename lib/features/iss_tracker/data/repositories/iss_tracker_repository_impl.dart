import '../../domain/entities/iss_position_entity.dart';
import '../../domain/repositories/iss_tracker_repository.dart';
import '../datasources/iss_tracker_remote_datasource.dart';

class IssTrackerRepositoryImpl implements IssTrackerRepository {
  final IssTrackerRemoteDataSource dataSource;
  IssTrackerRepositoryImpl(this.dataSource);

  @override
  Future<IssPositionEntity> getIssPosition() async {
    final model = await dataSource.getIssPosition();
    return model.toEntity();
  }
}
