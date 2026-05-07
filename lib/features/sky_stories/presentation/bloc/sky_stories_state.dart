part of 'sky_stories_bloc.dart';

abstract class SkyStoriesState extends Equatable {
  const SkyStoriesState();

  @override
  List<Object?> get props => [];
}

class SkyStoriesInitial extends SkyStoriesState {
  const SkyStoriesInitial();
}

class SkyStoriesLoading extends SkyStoriesState {
  const SkyStoriesLoading();
}

class SkyStoriesLoaded extends SkyStoriesState {
  final List<ApodEntity> pictures;

  const SkyStoriesLoaded({required this.pictures});

  @override
  List<Object?> get props => [pictures];
}

class SkyStoriesError extends SkyStoriesState {
  final String message;

  const SkyStoriesError(this.message);

  @override
  List<Object?> get props => [message];
}
