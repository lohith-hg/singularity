part of 'saved_bloc.dart';

abstract class SavedState extends Equatable {
  const SavedState();

  @override
  List<Object?> get props => [];
}

class SavedInitial extends SavedState {
  const SavedInitial();
}

class SavedLoading extends SavedState {
  const SavedLoading();
}

class SavedLoaded extends SavedState {
  final List<SavedItemEntity> items;
  const SavedLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class SavedError extends SavedState {
  final String message;
  const SavedError(this.message);

  @override
  List<Object?> get props => [message];
}
