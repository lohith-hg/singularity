import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/exoplanet_entity.dart';
import '../../domain/usecases/get_exoplanets.dart';

part 'exoplanets_event.dart';
part 'exoplanets_state.dart';

class ExoplanetsBloc extends Bloc<ExoplanetsEvent, ExoplanetsState> {
  final GetExoplanets getExoplanets;
  List<ExoplanetEntity> _allPlanets = [];

  ExoplanetsBloc({required this.getExoplanets})
    : super(const ExoplanetsInitial()) {
    on<LoadExoplanetsEvent>(_onLoad);
    on<FilterExoplanetsEvent>(_onFilter);
  }

  Future<void> _onLoad(
    LoadExoplanetsEvent event,
    Emitter<ExoplanetsState> emit,
  ) async {
    emit(const ExoplanetsLoading());
    try {
      _allPlanets = await getExoplanets(NoParams());
      emit(ExoplanetsLoaded(planets: _allPlanets, filter: 'All'));
    } on ServerException catch (e) {
      emit(ExoplanetsError(e.message));
    } catch (e) {
      emit(ExoplanetsError(e.toString()));
    }
  }

  void _onFilter(FilterExoplanetsEvent event, Emitter<ExoplanetsState> emit) {
    final filtered = _applyFilter(_allPlanets, event.filter);
    emit(ExoplanetsLoaded(planets: filtered, filter: event.filter));
  }

  List<ExoplanetEntity> _applyFilter(
    List<ExoplanetEntity> planets,
    String filter,
  ) {
    switch (filter) {
      case 'Earth-like':
        return planets
            .where((p) => p.radiusEarth != null && p.radiusEarth! < 1.5)
            .toList();
      case 'Super-Earth':
        return planets
            .where(
              (p) =>
                  p.radiusEarth != null &&
                  p.radiusEarth! >= 1.5 &&
                  p.radiusEarth! < 2.5,
            )
            .toList();
      case 'Hot Jupiter':
        return planets
            .where(
              (p) =>
                  p.radiusEarth != null &&
                  p.radiusEarth! >= 8 &&
                  p.orbitalPeriodDays != null &&
                  p.orbitalPeriodDays! < 10,
            )
            .toList();
      case 'Habitable':
        return planets
            .where(
              (p) =>
                  p.orbitalPeriodDays != null &&
                  p.orbitalPeriodDays! > 200 &&
                  p.orbitalPeriodDays! < 500,
            )
            .toList();
      default:
        return planets;
    }
  }
}
