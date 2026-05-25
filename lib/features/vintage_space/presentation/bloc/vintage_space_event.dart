part of 'vintage_space_bloc.dart';

abstract class VintageSpaceEvent {}

class LoadVintageSpaceEvent extends VintageSpaceEvent {}

// Re-picks 8 random topics and re-fetches — replaces calling onInit() directly.
class RefreshVintageSpaceEvent extends VintageSpaceEvent {}

class SearchVintageSpaceEvent extends VintageSpaceEvent {
  final String query;
  SearchVintageSpaceEvent(this.query);
}

class ClearVintageSpaceSearchEvent extends VintageSpaceEvent {}
