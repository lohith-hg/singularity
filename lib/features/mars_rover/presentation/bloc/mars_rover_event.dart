part of 'mars_rover_bloc.dart';

abstract class MarsRoverEvent {}

/// Loads all three rovers in parallel — used when "All" tab is the default.
class LoadAllRoversEvent extends MarsRoverEvent {}

/// Forces a fresh page-1 fetch for a single rover (e.g. pull-to-refresh).
class LoadRoverPhotosEvent extends MarsRoverEvent {
  final String rover;
  LoadRoverPhotosEvent({required this.rover});
}

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
