import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cached_resource.dart';
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
    on<RefreshMarsRoverEvent>(_onRefresh);
    on<SelectRoverEvent>(_onSelect);
    on<LoadMoreRoverPhotosEvent>(_onLoadMore);
  }

  static List<T> _shuffled<T>(List<T> list) => List.of(list)..shuffle(Random());

  // ── Load all three rovers — SWR: show cache immediately, refresh if stale ──

  Future<void> _onLoadAll(
    LoadAllRoversEvent event,
    Emitter<MarsRoverState> emit,
  ) async {
    final List<CachedResource<List<RoverPhotoEntity>>> resources =
        await Future.wait([
          getRoverPhotos(const RoverParams(rover: 'curiosity', page: 1)),
          getRoverPhotos(const RoverParams(rover: 'perseverance', page: 1)),
          getRoverPhotos(const RoverParams(rover: 'opportunity', page: 1)),
        ]);

    final cachedC = resources[0].cached;
    final cachedP = resources[1].cached;
    final cachedO = resources[2].cached;
    final hasCached = cachedC != null || cachedP != null || cachedO != null;

    if (hasCached) {
      final List<RoverPhotoEntity> c = _shuffled(
        cachedC ?? <RoverPhotoEntity>[],
      );
      final List<RoverPhotoEntity> p = _shuffled(
        cachedP ?? <RoverPhotoEntity>[],
      );
      final List<RoverPhotoEntity> o = _shuffled(
        cachedO ?? <RoverPhotoEntity>[],
      );
      emit(
        MarsRoverLoaded(
          activeRover: 'all',
          allPhotos: _shuffled([...c, ...p, ...o]),
          cache: {
            if (cachedC != null)
              'curiosity': RoverCache(
                photos: c,
                page: 1,
                hasReachedEnd: cachedC.length < 25,
              ),
            if (cachedP != null)
              'perseverance': RoverCache(
                photos: p,
                page: 1,
                hasReachedEnd: cachedP.length < 25,
              ),
            if (cachedO != null)
              'opportunity': RoverCache(
                photos: o,
                page: 1,
                hasReachedEnd: cachedO.length < 25,
              ),
          },
        ),
      );
    } else {
      emit(const MarsRoverLoading());
    }

    final anyStale = resources.any((r) => r.isStale);
    if (anyStale) {
      try {
        final List<List<RoverPhotoEntity>> refreshed =
            await Future.wait<List<RoverPhotoEntity>>([
              resources[0].isStale
                  ? resources[0].refresh()
                  : Future.value(cachedC ?? <RoverPhotoEntity>[]),
              resources[1].isStale
                  ? resources[1].refresh()
                  : Future.value(cachedP ?? <RoverPhotoEntity>[]),
              resources[2].isStale
                  ? resources[2].refresh()
                  : Future.value(cachedO ?? <RoverPhotoEntity>[]),
            ]);

        final List<RoverPhotoEntity> c = _shuffled(refreshed[0]);
        final List<RoverPhotoEntity> p = _shuffled(refreshed[1]);
        final List<RoverPhotoEntity> o = _shuffled(refreshed[2]);
        emit(
          MarsRoverLoaded(
            activeRover: 'all',
            allPhotos: _shuffled([...c, ...p, ...o]),
            cache: {
              'curiosity': RoverCache(
                photos: c,
                page: 1,
                hasReachedEnd: refreshed[0].length < 25,
              ),
              'perseverance': RoverCache(
                photos: p,
                page: 1,
                hasReachedEnd: refreshed[1].length < 25,
              ),
              'opportunity': RoverCache(
                photos: o,
                page: 1,
                hasReachedEnd: refreshed[2].length < 25,
              ),
            },
          ),
        );
      } on ServerException catch (e) {
        if (!hasCached) emit(MarsRoverError(e.message));
      } catch (e) {
        if (!hasCached) emit(MarsRoverError(e.toString()));
      }
    }
  }

  // ── Force fresh single-rover load ──────────────────────────────────────────

  Future<void> _onLoad(
    LoadRoverPhotosEvent event,
    Emitter<MarsRoverState> emit,
  ) async {
    emit(const MarsRoverLoading());
    try {
      final res = await getRoverPhotos(
        RoverParams(rover: event.rover, page: 1),
      );
      final photos = res.cached ?? await res.refresh();
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

  // ── Pull-to-refresh — force a fresh network fetch for the active tab ────────

  Future<void> _onRefresh(
    RefreshMarsRoverEvent event,
    Emitter<MarsRoverState> emit,
  ) async {
    final current = state;
    final activeRover = current is MarsRoverLoaded
        ? current.activeRover
        : 'all';

    try {
      if (activeRover == 'all') {
        final resources = await Future.wait([
          getRoverPhotos(const RoverParams(rover: 'curiosity', page: 1)),
          getRoverPhotos(const RoverParams(rover: 'perseverance', page: 1)),
          getRoverPhotos(const RoverParams(rover: 'opportunity', page: 1)),
        ]);
        // refresh() always hits the network and overwrites the cache.
        final refreshed = await Future.wait<List<RoverPhotoEntity>>([
          resources[0].refresh(),
          resources[1].refresh(),
          resources[2].refresh(),
        ]);
        final c = _shuffled(refreshed[0]);
        final p = _shuffled(refreshed[1]);
        final o = _shuffled(refreshed[2]);
        emit(
          MarsRoverLoaded(
            activeRover: 'all',
            allPhotos: _shuffled([...c, ...p, ...o]),
            cache: {
              'curiosity': RoverCache(
                photos: c,
                page: 1,
                hasReachedEnd: refreshed[0].length < 25,
              ),
              'perseverance': RoverCache(
                photos: p,
                page: 1,
                hasReachedEnd: refreshed[1].length < 25,
              ),
              'opportunity': RoverCache(
                photos: o,
                page: 1,
                hasReachedEnd: refreshed[2].length < 25,
              ),
            },
          ),
        );
      } else {
        final res = await getRoverPhotos(
          RoverParams(rover: activeRover, page: 1),
        );
        final photos = _shuffled(await res.refresh());
        final newCache = RoverCache(
          photos: photos,
          page: 1,
          hasReachedEnd: photos.length < 25,
        );
        final updated = state;
        emit(
          updated is MarsRoverLoaded
              ? updated.withCacheUpdate(activeRover, newCache)
              : MarsRoverLoaded(
                  activeRover: activeRover,
                  cache: {activeRover: newCache},
                ),
        );
      }
    } on ServerException catch (e) {
      if (current is! MarsRoverLoaded) emit(MarsRoverError(e.message));
    } catch (e) {
      if (current is! MarsRoverLoaded) emit(MarsRoverError(e.toString()));
    }
  }

  // ── Switch active rover tab ─────────────────────────────────────────────────

  Future<void> _onSelect(
    SelectRoverEvent event,
    Emitter<MarsRoverState> emit,
  ) async {
    final current = state;
    if (current is! MarsRoverLoaded) return;

    if (event.rover == 'all') {
      emit(current.copyWith(activeRover: 'all'));
      return;
    }

    if (current.cache.containsKey(event.rover)) {
      emit(current.copyWith(activeRover: event.rover));
      return;
    }

    emit(current.copyWith(activeRover: event.rover));
    try {
      final res = await getRoverPhotos(
        RoverParams(rover: event.rover, page: 1),
      );
      final photos = res.cached ?? await res.refresh();
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
      final res = await getRoverPhotos(
        RoverParams(rover: event.rover, page: event.nextPage),
      );
      final newPhotos = res.cached ?? await res.refresh();
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
