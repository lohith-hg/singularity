import '../entities/neo_entity.dart';

abstract class NeoRepository {
  Future<List<NeoEntity>> getNeos({
    required String startDate,
    required String endDate,
  });
}
