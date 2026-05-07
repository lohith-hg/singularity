part of 'sky_stories_bloc.dart';

abstract class SkyStoriesEvent {}

class LoadSkyStoriesEvent extends SkyStoriesEvent {}

// Shuffles the already-loaded list without re-fetching from the API.
class ShuffleSkyStoriesEvent extends SkyStoriesEvent {}
