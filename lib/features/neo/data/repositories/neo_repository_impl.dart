import '../../domain/entities/neo_entity.dart';
import '../../domain/repositories/neo_repository.dart';
import '../datasources/neo_remote_datasource.dart';

class NeoRepositoryImpl implements NeoRepository {
  final NeoRemoteDataSource dataSource;
  NeoRepositoryImpl(this.dataSource);

  @override
  Future<List<NeoEntity>> getNeos({
    required String startDate,
    required String endDate,
  }) async {
    final models = await dataSource.getNeos(
      startDate: startDate,
      endDate: endDate,
    );
    return models.map((m) => m.toEntity()).toList();
  }
}
