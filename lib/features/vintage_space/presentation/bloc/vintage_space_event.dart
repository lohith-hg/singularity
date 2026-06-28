part of 'vintage_space_bloc.dart';

abstract class VintageSpaceEvent {}

class LoadVintageSpaceEvent extends VintageSpaceEvent {}

// Force refresh (pull-to-refresh or header button): always hits the network,
// re-picking 8 random topics and bypassing the cache TTL.
class RefreshVintageSpaceEvent extends VintageSpaceEvent {}

class SearchVintageSpaceEvent extends VintageSpaceEvent {
  final String query;
  SearchVintageSpaceEvent(this.query);
}

class ClearVintageSpaceSearchEvent extends VintageSpaceEvent {}
