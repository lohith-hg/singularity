import '../../../../core/services/cached_resource.dart';
import '../entities/neo_entity.dart';

abstract class NeoRepository {
  CachedResource<List<NeoEntity>> getNeos({
    required String startDate,
    required String endDate,
  });
}
