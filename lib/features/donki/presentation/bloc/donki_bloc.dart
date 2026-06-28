import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/space_weather_event_entity.dart';
import '../../domain/usecases/get_space_weather_events.dart';

part 'donki_event.dart';
part 'donki_state.dart';

class DonkiBloc extends Bloc<DonkiEvent, DonkiState> {
  final GetSpaceWeatherEvents getSpaceWeatherEvents;

  DonkiBloc({required this.getSpaceWeatherEvents})
      : super(const DonkiInitial()) {
    on<LoadSpaceWeatherEvent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadSpaceWeatherEvent event,
    Emitter<DonkiState> emit,
  ) async {
    final today = DateTime.now();
    final sevenDaysAgo = today.subtract(const Duration(days: 7));

    final res = await getSpaceWeatherEvents(
      DonkiParams(
        startDate: _formatDate(sevenDaysAgo),
        endDate: _formatDate(today),
      ),
    );

    final cached = res.cached;
    if (cached != null) {
      final sorted = List.of(cached)..sort((a, b) => b.time.compareTo(a.time));
      emit(DonkiLoaded(events: sorted));
    } else {
      emit(const DonkiLoading());
    }
    if (res.isStale) {
      try {
        final fresh = await res.refresh();
        final sorted = List.of(fresh)
          ..sort((a, b) => b.time.compareTo(a.time));
        emit(DonkiLoaded(events: sorted));
      } on ServerException catch (e) {
        if (cached == null) emit(DonkiError(e.message));
      } catch (e) {
        if (cached == null) emit(DonkiError(e.toString()));
      }
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
