part of 'explore_bloc.dart';

abstract class ExploreEvent {}

// Dispatched when the Explore tab is first opened.
class LoadExploreDataEvent extends ExploreEvent {}
