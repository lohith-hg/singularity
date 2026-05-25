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
    emit(const NeoLoading());
    try {
      final now = DateTime.now();
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final sunday = monday.add(const Duration(days: 6));

      final neos = await getNeos(
        NeoParams(startDate: _formatDate(monday), endDate: _formatDate(sunday)),
      );

      // Sort by closeApproachDate ascending
      neos.sort((a, b) => a.closeApproachDate.compareTo(b.closeApproachDate));

      emit(NeoLoaded(neos: neos));
    } on ServerException catch (e) {
      emit(NeoError(e.message));
    } catch (e) {
      emit(NeoError(e.toString()));
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
