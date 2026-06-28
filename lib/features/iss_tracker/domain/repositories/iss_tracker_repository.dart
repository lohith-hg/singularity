import '../entities/iss_position_entity.dart';

abstract class IssTrackerRepository {
  Future<IssPositionEntity> getIssPosition();
}
