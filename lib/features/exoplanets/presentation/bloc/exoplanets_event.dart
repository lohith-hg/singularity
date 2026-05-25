part of 'exoplanets_bloc.dart';

abstract class ExoplanetsEvent {}

class LoadExoplanetsEvent extends ExoplanetsEvent {}

class FilterExoplanetsEvent extends ExoplanetsEvent {
  final String filter;
  FilterExoplanetsEvent({required this.filter});
}
