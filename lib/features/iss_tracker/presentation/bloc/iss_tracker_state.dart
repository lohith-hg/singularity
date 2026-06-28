part of 'iss_tracker_bloc.dart';

abstract class IssTrackerState extends Equatable {
  const IssTrackerState();

  @override
  List<Object?> get props => [];
}

class IssTrackerInitial extends IssTrackerState {
  const IssTrackerInitial();
}

class IssTrackerLoading extends IssTrackerState {
  const IssTrackerLoading();
}

class IssTrackerUpdated extends IssTrackerState {
  final IssPositionEntity position;

  const IssTrackerUpdated({required this.position});

  @override
  List<Object?> get props => [position.lat, position.lon, position.timestamp];
}

class IssTrackerError extends IssTrackerState {
  final String message;

  const IssTrackerError(this.message);

  @override
  List<Object?> get props => [message];
}
