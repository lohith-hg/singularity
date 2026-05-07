part of 'vintage_space_bloc.dart';

abstract class VintageSpaceState extends Equatable {
  const VintageSpaceState();

  @override
  List<Object?> get props => [];
}

class VintageSpaceInitial extends VintageSpaceState {
  const VintageSpaceInitial();
}

class VintageSpaceLoading extends VintageSpaceState {
  const VintageSpaceLoading();
}

class VintageSpaceLoaded extends VintageSpaceState {
  final List<NasaImageEntity> images;

  const VintageSpaceLoaded({required this.images});

  @override
  List<Object?> get props => [images];
}

class VintageSpaceError extends VintageSpaceState {
  final String message;

  const VintageSpaceError(this.message);

  @override
  List<Object?> get props => [message];
}
