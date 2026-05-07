import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../shared/entities/apod_entity.dart';
import '../../domain/usecases/get_apod_pictures.dart';

part 'cosmo_daily_event.dart';
part 'cosmo_daily_state.dart';

class CosmoDailyBloc extends Bloc<CosmoDailyEvent, CosmoDailyState> {
  final GetApodPictures getApodPictures;

  CosmoDailyBloc({required this.getApodPictures})
      : super(const CosmoDailyInitial()) {
    on<LoadCosmoDailyEvent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadCosmoDailyEvent event,
    Emitter<CosmoDailyState> emit,
  ) async {
    emit(const CosmoDailyLoading());
    try {
      final pictures = await getApodPictures(
        ApodParams(startDate: DateTime.now(), daysBack: 30),
      );
      emit(CosmoDailyLoaded(pictures: pictures));
    } on ServerException catch (e) {
      emit(CosmoDailyError(e.message));
    } catch (e) {
      emit(CosmoDailyError(e.toString()));
    }
  }
}
