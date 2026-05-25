import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/iss_position_entity.dart';
import '../../domain/usecases/get_iss_position.dart';

part 'iss_tracker_event.dart';
part 'iss_tracker_state.dart';

class IssTrackerBloc extends Bloc<IssTrackerEvent, IssTrackerState> {
  final GetIssPosition getIssPosition;
  Timer? _timer;

  IssTrackerBloc({required this.getIssPosition})
    : super(const IssTrackerInitial()) {
    on<LoadIssPositionEvent>(_onLoad);
    on<IssTrackerStopped>(_onStop);
  }

  Future<void> _onLoad(
    LoadIssPositionEvent event,
    Emitter<IssTrackerState> emit,
  ) async {
    emit(const IssTrackerLoading());

    // Fetch first position
    try {
      final position = await getIssPosition(NoParams());
      emit(IssTrackerUpdated(position: position));
    } on ServerException catch (e) {
      emit(IssTrackerError(e.message));
      return;
    } catch (e) {
      emit(IssTrackerError(e.toString()));
      return;
    }

    // Start periodic polling using emitter stream
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!isClosed) {
        try {
          final position = await getIssPosition(NoParams());
          // Emit directly by re-adding an event is not possible mid-emitter.
          // We keep a StreamController approach: re-add the load event
          // which won't re-emit Loading since we guard with isClosed.
          // Actually we store position and call emit via a completer approach.
          // Simplest: use a callback stored on the bloc.
          _positionController.add(position);
        } catch (_) {
          // Silently ignore periodic errors after first success
        }
      }
    });

    // Listen to the stream until the emitter is done
    await emit.forEach<IssPositionEntity>(
      _positionController.stream,
      onData: (position) => IssTrackerUpdated(position: position),
    );
  }

  Future<void> _onStop(
    IssTrackerStopped event,
    Emitter<IssTrackerState> emit,
  ) async {
    _timer?.cancel();
    _timer = null;
  }

  final StreamController<IssPositionEntity> _positionController =
      StreamController<IssPositionEntity>.broadcast();

  @override
  Future<void> close() {
    _timer?.cancel();
    _positionController.close();
    return super.close();
  }
}
