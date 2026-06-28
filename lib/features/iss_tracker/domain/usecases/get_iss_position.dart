import '../../../../core/usecases/usecase.dart';
import '../entities/iss_position_entity.dart';
import '../repositories/iss_tracker_repository.dart';

class GetIssPosition implements UseCase<IssPositionEntity, NoParams> {
  final IssTrackerRepository repository;
  GetIssPosition(this.repository);

  @override
  Future<IssPositionEntity> call(NoParams params) {
    return repository.getIssPosition();
  }
}
