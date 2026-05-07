import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/nasa_image_entity.dart';
import '../../domain/usecases/get_vintage_images.dart';

part 'vintage_space_event.dart';
part 'vintage_space_state.dart';

class VintageSpaceBloc extends Bloc<VintageSpaceEvent, VintageSpaceState> {
  final GetVintageImages getVintageImages;

  VintageSpaceBloc({required this.getVintageImages})
      : super(const VintageSpaceInitial()) {
    on<LoadVintageSpaceEvent>(_onLoad);
    on<RefreshVintageSpaceEvent>(_onLoad);
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
}
