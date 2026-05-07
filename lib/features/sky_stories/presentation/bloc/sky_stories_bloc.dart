import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../shared/entities/apod_entity.dart';
import '../../domain/usecases/get_sky_stories.dart';

part 'sky_stories_event.dart';
part 'sky_stories_state.dart';

class SkyStoriesBloc extends Bloc<SkyStoriesEvent, SkyStoriesState> {
  final GetSkyStories getSkyStories;

  SkyStoriesBloc({required this.getSkyStories})
      : super(const SkyStoriesInitial()) {
    on<LoadSkyStoriesEvent>(_onLoad);
    on<ShuffleSkyStoriesEvent>(_onShuffle);
  }

  Future<void> _onLoad(
    LoadSkyStoriesEvent event,
    Emitter<SkyStoriesState> emit,
  ) async {
    emit(const SkyStoriesLoading());
    try {
      final pictures = await getSkyStories(NoParams());
      emit(SkyStoriesLoaded(pictures: pictures));
    } catch (e) {
      emit(SkyStoriesError(e.toString()));
    }
  }

  void _onShuffle(
    ShuffleSkyStoriesEvent event,
    Emitter<SkyStoriesState> emit,
  ) {
    final current = state;
    if (current is SkyStoriesLoaded) {
      // Create a new shuffled list — BLoC states must be immutable
      final shuffled = List<ApodEntity>.from(current.pictures)..shuffle();
      emit(SkyStoriesLoaded(pictures: shuffled));
    }
  }
}
