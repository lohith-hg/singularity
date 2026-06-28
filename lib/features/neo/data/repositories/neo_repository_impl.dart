import '../../../../core/services/cached_resource.dart';
import '../../domain/entities/neo_entity.dart';
import '../../domain/repositories/neo_repository.dart';
import '../datasources/neo_remote_datasource.dart';

class NeoRepositoryImpl implements NeoRepository {
  final NeoRemoteDataSource dataSource;
  NeoRepositoryImpl(this.dataSource);

  @override
  CachedResource<List<NeoEntity>> getNeos({
    required String startDate,
    required String endDate,
  }) =>
      dataSource
          .getNeos(startDate: startDate, endDate: endDate)
          .map((models) => models.map((m) => m.toEntity()).toList());
}
