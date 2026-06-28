import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/epic_image_entity.dart';
import '../../domain/usecases/get_epic_images.dart';

part 'epic_event.dart';
part 'epic_state.dart';

class EpicBloc extends Bloc<EpicEvent, EpicState> {
  final GetEpicImages getEpicImages;

  EpicBloc({required this.getEpicImages}) : super(const EpicInitial()) {
    on<LoadEpicImagesEvent>(_onLoad);
  }

  static List<T> _shuffled<T>(List<T> l) => List.of(l)..shuffle(Random());

  Future<void> _onLoad(
    LoadEpicImagesEvent event,
    Emitter<EpicState> emit,
  ) async {
    final res = await getEpicImages(NoParams());
    final cached = res.cached;
    if (cached != null) {
      emit(EpicLoaded(images: _shuffled(cached)));
    } else {
      emit(const EpicLoading());
    }
    if (res.isStale) {
      try {
        emit(EpicLoaded(images: _shuffled(await res.refresh())));
      } on ServerException catch (e) {
        if (cached == null) emit(EpicError(e.message));
      } catch (e) {
        if (cached == null) emit(EpicError(e.toString()));
      }
    }
  }
}
