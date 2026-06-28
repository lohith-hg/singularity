import '../../../../core/services/cached_resource.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/neo_entity.dart';
import '../repositories/neo_repository.dart';

class NeoParams {
  final String startDate;
  final String endDate;
  const NeoParams({required this.startDate, required this.endDate});
}

class GetNeos implements UseCase<CachedResource<List<NeoEntity>>, NeoParams> {
  final NeoRepository repository;
  GetNeos(this.repository);

  @override
  Future<CachedResource<List<NeoEntity>>> call(NeoParams params) async =>
      repository.getNeos(
        startDate: params.startDate,
        endDate: params.endDate,
      );
}
