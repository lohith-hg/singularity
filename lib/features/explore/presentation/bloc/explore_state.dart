part of 'explore_bloc.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {
  const ExploreInitial();
}

class ExploreLoading extends ExploreState {
  const ExploreLoading();
}

class ExploreLoaded extends ExploreState {
  final List<PlanetEntity> planets;
  final List<ArticleEntity> articles;

  const ExploreLoaded({required this.planets, required this.articles});

  @override
  List<Object?> get props => [planets, articles];
}

class ExploreError extends ExploreState {
  final String message;

  const ExploreError(this.message);

  @override
  List<Object?> get props => [message];
}
