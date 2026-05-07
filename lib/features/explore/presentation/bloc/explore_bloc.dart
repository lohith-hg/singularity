import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/article_entity.dart';
import '../../domain/entities/planet_entity.dart';
import '../../domain/usecases/get_articles.dart';
import '../../domain/usecases/get_planets.dart';

part 'explore_event.dart';
part 'explore_state.dart';

// ExploreBloc manages the lifecycle of explore data.
// Events come in (LoadExploreDataEvent), states go out (ExploreLoaded, etc.).
class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetPlanets getPlanets;
  final GetArticles getArticles;

  ExploreBloc({required this.getPlanets, required this.getArticles})
      : super(const ExploreInitial()) {
    on<LoadExploreDataEvent>(_onLoadExploreData);
  }

  Future<void> _onLoadExploreData(
    LoadExploreDataEvent event,
    Emitter<ExploreState> emit,
  ) async {
    emit(const ExploreLoading());
    try {
      final planets = await getPlanets(NoParams());
      final articles = await getArticles(NoParams());
      emit(ExploreLoaded(planets: planets, articles: articles));
    } catch (e) {
      emit(ExploreError(e.toString()));
    }
  }
}
