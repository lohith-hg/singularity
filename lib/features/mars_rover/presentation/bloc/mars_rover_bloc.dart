import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/rover_photo_entity.dart';
import '../../domain/usecases/get_rover_photos.dart';

part 'mars_rover_event.dart';
part 'mars_rover_state.dart';

class MarsRoverBloc extends Bloc<MarsRoverEvent, MarsRoverState> {
  final GetRoverPhotos getRoverPhotos;

  MarsRoverBloc({required this.getRoverPhotos})
    : super(const MarsRoverInitial()) {
    on<LoadAllRoversEvent>(_onLoadAll);
    on<LoadRoverPhotosEvent>(_onLoad);
    on<SelectRoverEvent>(_onSelect);
    on<LoadMoreRoverPhotosEvent>(_onLoadMore);
  }

  static List<T> _shuffled<T>(List<T> list) => list..shuffle(Random());

  // ── Load all three rovers in parallel ──────────────────────────────────────

  Future<void> _onLoadAll(
    LoadAllRoversEvent event,
    Emitter<MarsRoverState> emit,
  ) async {
    emit(const MarsRoverLoading());
    try {
      final results = await Future.wait([
        getRoverPhotos(RoverParams(rover: 'curiosity', page: 1)),
        getRoverPhotos(RoverParams(rover: 'perseverance', page: 1)),
        getRoverPhotos(RoverParams(rover: 'opportunity', page: 1)),
      ]);

      final curiosityPhotos = _shuffled(results[0]);
      final perseverancePhotos = _shuffled(results[1]);
      final opportunityPhotos = _shuffled(results[2]);
      emit(
        MarsRoverLoaded(
          activeRover: 'all',
          allPhotos: _shuffled([
            ...curiosityPhotos,
            ...perseverancePhotos,
            ...opportunityPhotos,
          ]),
          cache: {
            'curiosity': RoverCache(
              photos: curiosityPhotos,
              page: 1,
              hasReachedEnd: results[0].length < 25,
            ),
            'perseverance': RoverCache(
              photos: perseverancePhotos,
              page: 1,
              hasReachedEnd: results[1].length < 25,
            ),
            'opportunity': RoverCache(
              photos: opportunityPhotos,
              page: 1,
              hasReachedEnd: results[2].length < 25,
            ),
          },
        ),
      );
    } on ServerException catch (e) {
      emit(MarsRoverError(e.message));
    } catch (e) {
      emit(MarsRoverError(e.toString()));
    }
  }

  // ── Force fresh single-rover load ──────────────────────────────────────────

  Future<void> _onLoad(
    LoadRoverPhotosEvent event,
    Emitter<MarsRoverState> emit,
  ) async {
    emit(const MarsRoverLoading());
    try {
      final photos = await getRoverPhotos(
        RoverParams(rover: event.rover, page: 1),
      );
      emit(
        MarsRoverLoaded(
          activeRover: event.rover,
          cache: {
            event.rover: RoverCache(
              photos: _shuffled(photos),
              page: 1,
              hasReachedEnd: photos.length < 25,
            ),
          },
        ),
      );
    } on ServerException catch (e) {
      emit(MarsRoverError(e.message));
    } catch (e) {
      emit(MarsRoverError(e.toString()));
    }
  }

  // ── Switch active rover tab ─────────────────────────────────────────────────

  Future<void> _onSelect(
    SelectRoverEvent event,
    Emitter<MarsRoverState> emit,
  ) async {
    final current = state;
    if (current is! MarsRoverLoaded) return;

    // "All" tab never needs a fetch — just flip the active key
    if (event.rover == 'all') {
      emit(current.copyWith(activeRover: 'all'));
      return;
    }

    // Already cached — instant switch, no API call
    if (current.cache.containsKey(event.rover)) {
      emit(current.copyWith(activeRover: event.rover));
      return;
    }

    // Not yet cached — show loading state for this rover then fetch
    emit(current.copyWith(activeRover: event.rover));
    try {
      final photos = await getRoverPhotos(
        RoverParams(rover: event.rover, page: 1),
      );
      final updated = state as MarsRoverLoaded;
      emit(
        updated.withCacheUpdate(
          event.rover,
          RoverCache(
            photos: _shuffled(photos),
            page: 1,
            hasReachedEnd: photos.length < 25,
          ),
        ),
      );
    } on ServerException catch (e) {
      emit(MarsRoverError(e.message));
    } catch (e) {
      emit(MarsRoverError(e.toString()));
    }
  }

  // ── Paginate ───────────────────────────────────────────────────────────────

  Future<void> _onLoadMore(
    LoadMoreRoverPhotosEvent event,
    Emitter<MarsRoverState> emit,
  ) async {
    final current = state;
    if (current is! MarsRoverLoaded) return;
    final roverCache = current.cache[event.rover];
    if (roverCache == null ||
        roverCache.isLoadingMore ||
        roverCache.hasReachedEnd) {
      return;
    }

    emit(
      current.withCacheUpdate(
        event.rover,
        roverCache.copyWith(isLoadingMore: true),
      ),
    );
    try {
      final newPhotos = await getRoverPhotos(
        RoverParams(rover: event.rover, page: event.nextPage),
      );
      final updatedState = state as MarsRoverLoaded;
      final updatedCache = updatedState.cache[event.rover]!;
      emit(
        updatedState.withCacheUpdate(
          event.rover,
          updatedCache.copyWith(
            photos: [...updatedCache.photos, ..._shuffled(newPhotos)],
            page: event.nextPage,
            isLoadingMore: false,
            hasReachedEnd: newPhotos.length < 25,
          ),
        ),
      );
    } on ServerException {
      final updatedState = state as MarsRoverLoaded;
      final updatedCache = updatedState.cache[event.rover]!;
      emit(
        updatedState.withCacheUpdate(
          event.rover,
          updatedCache.copyWith(isLoadingMore: false),
        ),
      );
    } catch (_) {
      final updatedState = state as MarsRoverLoaded;
      final updatedCache = updatedState.cache[event.rover]!;
      emit(
        updatedState.withCacheUpdate(
          event.rover,
          updatedCache.copyWith(isLoadingMore: false),
        ),
      );
    }
  }
}
