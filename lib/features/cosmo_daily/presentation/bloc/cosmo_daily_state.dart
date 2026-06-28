part of 'cosmo_daily_bloc.dart';

abstract class CosmoDailyState extends Equatable {
  const CosmoDailyState();

  @override
  List<Object?> get props => [];
}

class CosmoDailyInitial extends CosmoDailyState {
  const CosmoDailyInitial();
}

class CosmoDailyLoading extends CosmoDailyState {
  const CosmoDailyLoading();
}

class CosmoDailyLoaded extends CosmoDailyState {
  final List<ApodEntity> pictures;

  const CosmoDailyLoaded({required this.pictures});

  @override
  List<Object?> get props => [pictures];
}

class CosmoDailyError extends CosmoDailyState {
  final String message;

  const CosmoDailyError(this.message);

  @override
  List<Object?> get props => [message];
}
