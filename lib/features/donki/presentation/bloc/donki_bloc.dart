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
    emit(const DonkiLoading());
    try {
      final today = DateTime.now();
      final sevenDaysAgo = today.subtract(const Duration(days: 7));

      final events = await getSpaceWeatherEvents(
        DonkiParams(
          startDate: _formatDate(sevenDaysAgo),
          endDate: _formatDate(today),
        ),
      );

      // Sort by time descending
      events.sort((a, b) => b.time.compareTo(a.time));

      emit(DonkiLoaded(events: events));
    } on ServerException catch (e) {
      emit(DonkiError(e.message));
    } catch (e) {
      emit(DonkiError(e.toString()));
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
