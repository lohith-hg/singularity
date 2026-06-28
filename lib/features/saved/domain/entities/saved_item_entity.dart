import 'package:equatable/equatable.dart';

import '../../../shared/entities/apod_entity.dart';

class SavedItemEntity extends Equatable {
  final ApodEntity apod;
  final DateTime savedAt;

  const SavedItemEntity({required this.apod, required this.savedAt});

  @override
  List<Object?> get props => [apod.date];
}
