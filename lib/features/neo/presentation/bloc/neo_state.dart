part of 'neo_bloc.dart';

abstract class NeoState extends Equatable {
  const NeoState();

  @override
  List<Object?> get props => [];
}

class NeoInitial extends NeoState {
  const NeoInitial();
}

class NeoLoading extends NeoState {
  const NeoLoading();
}

class NeoLoaded extends NeoState {
  final List<NeoEntity> neos;

  const NeoLoaded({required this.neos});

  @override
  List<Object?> get props => [neos];
}

class NeoError extends NeoState {
  final String message;

  const NeoError(this.message);

  @override
  List<Object?> get props => [message];
}
