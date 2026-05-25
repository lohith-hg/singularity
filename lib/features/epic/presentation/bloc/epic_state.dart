part of 'epic_bloc.dart';

abstract class EpicState extends Equatable {
  const EpicState();

  @override
  List<Object?> get props => [];
}

class EpicInitial extends EpicState {
  const EpicInitial();
}

class EpicLoading extends EpicState {
  const EpicLoading();
}

class EpicLoaded extends EpicState {
  final List<EpicImageEntity> images;

  const EpicLoaded({required this.images});

  @override
  List<Object?> get props => [images];
}

class EpicError extends EpicState {
  final String message;

  const EpicError(this.message);

  @override
  List<Object?> get props => [message];
}
