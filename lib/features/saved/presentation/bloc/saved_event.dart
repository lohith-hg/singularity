part of 'saved_bloc.dart';

abstract class SavedEvent extends Equatable {
  const SavedEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavedItemsEvent extends SavedEvent {
  const LoadSavedItemsEvent();
}

class SaveApodEvent extends SavedEvent {
  final ApodEntity apod;
  const SaveApodEvent({required this.apod});

  @override
  List<Object?> get props => [apod];
}

class UnsaveApodEvent extends SavedEvent {
  final String apodDate;
  const UnsaveApodEvent({required this.apodDate});

  @override
  List<Object?> get props => [apodDate];
}
