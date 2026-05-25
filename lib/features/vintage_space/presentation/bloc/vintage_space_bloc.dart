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
    on<RefreshVintageSpaceEvent>(_onLoad);
    on<SearchVintageSpaceEvent>(_onSearch);
    on<ClearVintageSpaceSearchEvent>(_onClearSearch);
  }

  Future<void> _onLoad(
    VintageSpaceEvent event,
    Emitter<VintageSpaceState> emit,
  ) async {
    emit(const VintageSpaceLoading());
    try {
      final images = await getVintageImages(NoParams());
      emit(VintageSpaceLoaded(images: images));
    } catch (e) {
      emit(VintageSpaceError(e.toString()));
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
