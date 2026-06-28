part of 'iss_tracker_bloc.dart';

abstract class IssTrackerEvent {}

class LoadIssPositionEvent extends IssTrackerEvent {}

class IssTrackerStopped extends IssTrackerEvent {}
