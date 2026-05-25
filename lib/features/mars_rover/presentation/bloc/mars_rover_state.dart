part of 'mars_rover_bloc.dart';

class RoverCache extends Equatable {
  final List<RoverPhotoEntity> photos;
  final int page;
  final bool isLoadingMore;
  final bool hasReachedEnd;

  const RoverCache({
    required this.photos,
    required this.page,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
  });

  RoverCache copyWith({
    List<RoverPhotoEntity>? photos,
    int? page,
    bool? isLoadingMore,
    bool? hasReachedEnd,
  }) => RoverCache(
    photos: photos ?? this.photos,
    page: page ?? this.page,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
  );

  @override
  List<Object?> get props => [photos, page, isLoadingMore, hasReachedEnd];
}

abstract class MarsRoverState extends Equatable {
  const MarsRoverState();

  @override
  List<Object?> get props => [];
}

class MarsRoverInitial extends MarsRoverState {
  const MarsRoverInitial();
}

class MarsRoverLoading extends MarsRoverState {
  const MarsRoverLoading();
}

class MarsRoverLoaded extends MarsRoverState {
  final String activeRover;
  final Map<String, RoverCache> cache;
  final List<RoverPhotoEntity> allPhotos;

  const MarsRoverLoaded({
    required this.activeRover,
    required this.cache,
    this.allPhotos = const [],
  });

  List<RoverPhotoEntity> get currentPhotos {
    if (activeRover == 'all') return allPhotos;
    return cache[activeRover]?.photos ?? [];
  }

  bool get isLoadingMore => cache[activeRover]?.isLoadingMore ?? false;
  bool get hasReachedEnd => cache[activeRover]?.hasReachedEnd ?? false;
  int get currentPage => cache[activeRover]?.page ?? 1;

  MarsRoverLoaded copyWith({
    String? activeRover,
    Map<String, RoverCache>? cache,
    List<RoverPhotoEntity>? allPhotos,
  }) => MarsRoverLoaded(
    activeRover: activeRover ?? this.activeRover,
    cache: cache ?? this.cache,
    allPhotos: allPhotos ?? this.allPhotos,
  );

  MarsRoverLoaded withCacheUpdate(String rover, RoverCache updated) =>
      copyWith(cache: {...cache, rover: updated});

  @override
  List<Object?> get props => [activeRover, cache, allPhotos];
}

class MarsRoverError extends MarsRoverState {
  final String message;

  const MarsRoverError(this.message);

  @override
  List<Object?> get props => [message];
}
