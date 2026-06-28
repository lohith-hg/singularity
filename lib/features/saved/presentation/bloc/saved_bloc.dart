import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../shared/entities/apod_entity.dart';
import '../../domain/entities/saved_item_entity.dart';
import '../../domain/usecases/get_saved_items.dart';
import '../../domain/usecases/save_apod.dart';
import '../../domain/usecases/unsave_apod.dart';

part 'saved_event.dart';
part 'saved_state.dart';

class SavedBloc extends Bloc<SavedEvent, SavedState> {
  final GetSavedItems getSavedItems;
  final SaveApod saveApod;
  final UnsaveApod unsaveApod;

  SavedBloc({
    required this.getSavedItems,
    required this.saveApod,
    required this.unsaveApod,
  }) : super(const SavedInitial()) {
    on<LoadSavedItemsEvent>(_onLoad);
    on<SaveApodEvent>(_onSave);
    on<UnsaveApodEvent>(_onUnsave);
  }

  Future<void> _onLoad(
    LoadSavedItemsEvent event,
    Emitter<SavedState> emit,
  ) async {
    emit(const SavedLoading());
    try {
      final items = await getSavedItems();
      emit(SavedLoaded(items: items));
    } catch (e) {
      emit(SavedError(e.toString()));
    }
  }

  Future<void> _onSave(SaveApodEvent event, Emitter<SavedState> emit) async {
    try {
      await saveApod(event.apod);
      final items = await getSavedItems();
      emit(SavedLoaded(items: items));
    } catch (e) {
      emit(SavedError(e.toString()));
    }
  }

  Future<void> _onUnsave(
    UnsaveApodEvent event,
    Emitter<SavedState> emit,
  ) async {
    try {
      await unsaveApod(event.apodDate);
      final items = await getSavedItems();
      emit(SavedLoaded(items: items));
    } catch (e) {
      emit(SavedError(e.toString()));
    }
  }
}
