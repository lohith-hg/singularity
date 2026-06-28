part of 'donki_bloc.dart';

abstract class DonkiState extends Equatable {
  const DonkiState();

  @override
  List<Object?> get props => [];
}

class DonkiInitial extends DonkiState {
  const DonkiInitial();
}

class DonkiLoading extends DonkiState {
  const DonkiLoading();
}

class DonkiLoaded extends DonkiState {
  final List<SpaceWeatherEventEntity> events;

  const DonkiLoaded({required this.events});

  @override
  List<Object?> get props => [events];
}

class DonkiError extends DonkiState {
  final String message;

  const DonkiError(this.message);

  @override
  List<Object?> get props => [message];
}
