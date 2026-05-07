import '../../../../core/usecases/usecase.dart';
import '../../../shared/entities/apod_entity.dart';
import '../repositories/apod_repository.dart';

class ApodParams {
  final DateTime startDate;
  final int daysBack;
  const ApodParams({required this.startDate, required this.daysBack});
}

// Fetches APOD pictures and sorts them by date descending (newest first).
// The sort logic lives here — not in the BLoC or UI.
class GetApodPictures implements UseCase<List<ApodEntity>, ApodParams> {
  final ApodRepository repository;
  GetApodPictures(this.repository);

  @override
  Future<List<ApodEntity>> call(ApodParams params) async {
    final pictures = await repository.getApodPictures(
      startDate: params.startDate,
      daysBack: params.daysBack,
    );
    return pictures..sort((a, b) => b.date.compareTo(a.date));
  }
}
