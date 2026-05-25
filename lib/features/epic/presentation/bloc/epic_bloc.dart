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

  Future<void> _onLoad(
    LoadEpicImagesEvent event,
    Emitter<EpicState> emit,
  ) async {
    emit(const EpicLoading());
    try {
      final images = await getEpicImages(NoParams());
      emit(EpicLoaded(images: images));
    } on ServerException catch (e) {
      emit(EpicError(e.message));
    } catch (e) {
      emit(EpicError(e.toString()));
    }
  }
}
