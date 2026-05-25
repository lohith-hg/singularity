part of 'saved_bloc.dart';

abstract class SavedEvent extends Equatable {
  const SavedEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavedItemsEvent extends SavedEvent {
  final String uid;
  const LoadSavedItemsEvent(this.uid);

  @override
  List<Object?> get props => [uid];
}

class SaveApodEvent extends SavedEvent {
  final String uid;
  final ApodEntity apod;
  const SaveApodEvent({required this.uid, required this.apod});

  @override
  List<Object?> get props => [uid, apod];
}

class UnsaveApodEvent extends SavedEvent {
  final String uid;
  final String apodDate;
  const UnsaveApodEvent({required this.uid, required this.apodDate});

  @override
  List<Object?> get props => [uid, apodDate];
}
