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

class VintageSpaceSearching extends VintageSpaceState {
  final String query;

  const VintageSpaceSearching(this.query);

  @override
  List<Object?> get props => [query];
}

class VintageSpaceLoaded extends VintageSpaceState {
  final List<NasaImageEntity> images;
  final String? query;

  const VintageSpaceLoaded({required this.images, this.query});

  @override
  List<Object?> get props => [images, query];
}

class VintageSpaceError extends VintageSpaceState {
  final String message;

  const VintageSpaceError(this.message);

  @override
  List<Object?> get props => [message];
}
