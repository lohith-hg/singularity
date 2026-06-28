import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../shared/entities/apod_entity.dart';
import '../models/saved_item_model.dart';

abstract class SavedLocalDataSource {
  Future<List<SavedItemModel>> getSavedItems();
  Future<void> saveApod(ApodEntity apod);
  Future<void> unsaveApod(String apodDate);
}

class SavedLocalDataSourceImpl implements SavedLocalDataSource {
  final Box<dynamic> _box;
  SavedLocalDataSourceImpl(this._box);

  @override
  Future<List<SavedItemModel>> getSavedItems() async {
    final items =
        _box.values
            .map(
              (v) => SavedItemModel.fromMap(
                jsonDecode(v as String) as Map<String, dynamic>,
              ),
            )
            .toList()
          ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return items;
  }

  @override
  Future<void> saveApod(ApodEntity apod) async {
    final model = SavedItemModel(apod: apod, savedAt: DateTime.now());
    await _box.put(
      apod.date.toIso8601String().split('T').first,
      jsonEncode(model.toMap()),
    );
  }

  @override
  Future<void> unsaveApod(String apodDate) async {
    await _box.delete(apodDate.split('T').first);
  }
}
