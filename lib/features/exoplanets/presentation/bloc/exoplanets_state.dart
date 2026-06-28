part of 'exoplanets_bloc.dart';

abstract class ExoplanetsState extends Equatable {
  const ExoplanetsState();

  @override
  List<Object?> get props => [];
}

class ExoplanetsInitial extends ExoplanetsState {
  const ExoplanetsInitial();
}

class ExoplanetsLoading extends ExoplanetsState {
  const ExoplanetsLoading();
}

class ExoplanetsLoaded extends ExoplanetsState {
  final List<ExoplanetEntity> planets;
  final String filter;

  const ExoplanetsLoaded({required this.planets, required this.filter});

  @override
  List<Object?> get props => [planets, filter];
}

class ExoplanetsError extends ExoplanetsState {
  final String message;

  const ExoplanetsError(this.message);

  @override
  List<Object?> get props => [message];
}
