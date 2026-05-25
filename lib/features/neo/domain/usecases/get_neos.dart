import '../../../../core/usecases/usecase.dart';
import '../entities/neo_entity.dart';
import '../repositories/neo_repository.dart';

class NeoParams {
  final String startDate;
  final String endDate;
  const NeoParams({required this.startDate, required this.endDate});
}

class GetNeos implements UseCase<List<NeoEntity>, NeoParams> {
  final NeoRepository repository;
  GetNeos(this.repository);

  @override
  Future<List<NeoEntity>> call(NeoParams params) {
    return repository.getNeos(
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}
