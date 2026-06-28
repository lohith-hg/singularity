import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/neo_entity.dart';
import '../../domain/usecases/get_neos.dart';

part 'neo_event.dart';
part 'neo_state.dart';

class NeoBloc extends Bloc<NeoEvent, NeoState> {
  final GetNeos getNeos;

  NeoBloc({required this.getNeos}) : super(const NeoInitial()) {
    on<LoadNeosEvent>(_onLoad);
  }

  Future<void> _onLoad(LoadNeosEvent event, Emitter<NeoState> emit) async {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));

    final res = await getNeos(
      NeoParams(startDate: _formatDate(monday), endDate: _formatDate(sunday)),
    );

    final cached = res.cached;
    if (cached != null) {
      final sorted = List.of(cached)
        ..sort((a, b) => a.closeApproachDate.compareTo(b.closeApproachDate));
      emit(NeoLoaded(neos: sorted));
    } else {
      emit(const NeoLoading());
    }
    if (res.isStale) {
      try {
        final fresh = await res.refresh();
        final sorted = List.of(fresh)
          ..sort((a, b) => a.closeApproachDate.compareTo(b.closeApproachDate));
        emit(NeoLoaded(neos: sorted));
      } on ServerException catch (e) {
        if (cached == null) emit(NeoError(e.message));
      } catch (e) {
        if (cached == null) emit(NeoError(e.toString()));
      }
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
