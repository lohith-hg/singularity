part of 'mars_rover_bloc.dart';

abstract class MarsRoverEvent {}

/// Loads all three rovers in parallel — used when "All" tab is the default.
class LoadAllRoversEvent extends MarsRoverEvent {}

/// Forces a fresh page-1 fetch for a single rover (e.g. pull-to-refresh).
class LoadRoverPhotosEvent extends MarsRoverEvent {
  final String rover;
  LoadRoverPhotosEvent({required this.rover});
}

/// Pull-to-refresh: force a fresh network fetch for the active rover tab
/// (all three for "all", or the single selected rover), bypassing the cache
/// TTL. Keeps current content on screen until the new data arrives.
class RefreshMarsRoverEvent extends MarsRoverEvent {}

/// Switches the active rover tab; fetches from cache or network as needed.
class SelectRoverEvent extends MarsRoverEvent {
  final String rover;
  SelectRoverEvent({required this.rover});
}

class LoadMoreRoverPhotosEvent extends MarsRoverEvent {
  final String rover;
  final int nextPage;
  LoadMoreRoverPhotosEvent({required this.rover, required this.nextPage});
}
