import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../shared/entities/apod_entity.dart';
import '../../domain/usecases/fetch_apod_range.dart';
import '../../domain/usecases/get_apod_pictures.dart';

part 'cosmo_daily_event.dart';
part 'cosmo_daily_state.dart';

class CosmoDailyBloc extends Bloc<CosmoDailyEvent, CosmoDailyState> {
  CosmoDailyBloc({required this.getApodPictures, required this.fetchApodRange})
    : super(const CosmoDailyInitial()) {
    on<LoadCosmoDailyEvent>(_onLoad);
  }

  final GetApodPictures getApodPictures;
  final FetchApodRange fetchApodRange;

  Future<void> _onLoad(
    LoadCosmoDailyEvent event,
    Emitter<CosmoDailyState> emit,
  ) async {
    // Phase 1 — emit whatever is stored locally immediately.
    final (:apods, :isStale) = getApodPictures();
    if (apods.isNotEmpty) {
      emit(CosmoDailyLoaded(pictures: apods));
    } else {
      emit(const CosmoDailyLoading());
    }

    if (!isStale) return;

    // Phase 2 — fetch the 10 most recent days, paint the updated list.
    try {
      final fresh = await fetchApodRange.fetchInitial();
      emit(CosmoDailyLoaded(pictures: fresh));
    } on ServerException catch (e) {
      if (apods.isEmpty) emit(CosmoDailyError(e.message));
      return;
    } catch (e) {
      if (apods.isEmpty) emit(CosmoDailyError(e.toString()));
      return;
    }

    // Phase 3 — background: fetch the prior 25 days, silently extend the list.
    try {
      await fetchApodRange.fetchBackground();
      final all = getApodPictures().apods;
      emit(CosmoDailyLoaded(pictures: all));
    } catch (_) {
      // Background fetch failure is silent — user already has fresh Phase 2 data.
    }
  }
}
