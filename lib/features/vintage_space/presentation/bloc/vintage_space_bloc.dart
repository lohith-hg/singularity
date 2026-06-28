import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/nasa_image_entity.dart';
import '../../domain/usecases/get_vintage_images.dart';
import '../../domain/usecases/search_nasa_images.dart';

part 'vintage_space_event.dart';
part 'vintage_space_state.dart';

class VintageSpaceBloc extends Bloc<VintageSpaceEvent, VintageSpaceState> {
  final GetVintageImages getVintageImages;
  final SearchNasaImages searchNasaImages;

  VintageSpaceBloc({
    required this.getVintageImages,
    required this.searchNasaImages,
  }) : super(const VintageSpaceInitial()) {
    on<LoadVintageSpaceEvent>(_onLoad);
    on<RefreshVintageSpaceEvent>(_onRefresh);
    on<SearchVintageSpaceEvent>(_onSearch);
    on<ClearVintageSpaceSearchEvent>(_onClearSearch);
  }

  static List<T> _shuffled<T>(List<T> l) => List.of(l)..shuffle(Random());

  Future<void> _onLoad(
    VintageSpaceEvent event,
    Emitter<VintageSpaceState> emit,
  ) async {
    final res = await getVintageImages(NoParams());
    final cached = res.cached;
    if (cached != null) {
      emit(VintageSpaceLoaded(images: _shuffled(cached)));
    } else {
      emit(const VintageSpaceLoading());
    }
    if (res.isStale) {
      try {
        emit(VintageSpaceLoaded(images: _shuffled(await res.refresh())));
      } catch (e) {
        if (cached == null) emit(VintageSpaceError(e.toString()));
      }
    }
  }

  // Pull-to-refresh / manual refresh: always hits the network and re-picks a
  // fresh set of topics, bypassing the cache TTL. Existing content stays on
  // screen (no Loading emitted) until the new data arrives.
  Future<void> _onRefresh(
    RefreshVintageSpaceEvent event,
    Emitter<VintageSpaceState> emit,
  ) async {
    final current = state;
    final res = await getVintageImages(NoParams());
    try {
      emit(VintageSpaceLoaded(images: _shuffled(await res.refresh())));
    } catch (e) {
      if (current is! VintageSpaceLoaded) emit(VintageSpaceError(e.toString()));
    }
  }

  Future<void> _onSearch(
    SearchVintageSpaceEvent event,
    Emitter<VintageSpaceState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const VintageSpaceInitial());
      return;
    }

    emit(VintageSpaceSearching(query));
    try {
      final images = await searchNasaImages(query);
      emit(VintageSpaceLoaded(images: images, query: query));
    } catch (e) {
      emit(VintageSpaceError(e.toString()));
    }
  }

  void _onClearSearch(
    ClearVintageSpaceSearchEvent event,
    Emitter<VintageSpaceState> emit,
  ) {
    emit(const VintageSpaceInitial());
  }
}
