import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../shared/entities/apod_entity.dart';
import '../models/apod_model.dart';

abstract class ApodLocalDataSource {
  List<ApodEntity> getStoredApods();
  bool get isStale;
  Future<void> mergeApods(List<ApodEntity> apods);
  Future<void> markFilled();
}

class ApodLocalDataSourceImpl implements ApodLocalDataSource {
  ApodLocalDataSourceImpl(this._box);
  final Box<dynamic> _box;

  static const _lastFilledKey = '__last_filled';
  static const _staleDays = 7;

  @override
  List<ApodEntity> getStoredApods() {
    return _box.keys
        .where((k) => k != _lastFilledKey)
        .map((k) {
          try {
            final map =
                jsonDecode(_box.get(k) as String) as Map<String, dynamic>;
            return ApodModel.fromJson(map).toEntity();
          } catch (_) {
            return null;
          }
        })
        .whereType<ApodEntity>()
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  bool get isStale {
    final raw = _box.get(_lastFilledKey) as String?;
    if (raw == null) return true;
    final last = DateTime.tryParse(raw);
    if (last == null) return true;
    return DateTime.now().difference(last).inDays >= _staleDays;
  }

  @override
  Future<void> mergeApods(List<ApodEntity> apods) async {
    for (final apod in apods) {
      final key =
          '${apod.date.year}-${apod.date.month.toString().padLeft(2, '0')}-${apod.date.day.toString().padLeft(2, '0')}';
      await _box.put(key, jsonEncode(ApodModel.fromEntity(apod).toMap()));
    }
  }

  @override
  Future<void> markFilled() async {
    await _box.put(_lastFilledKey, DateTime.now().toIso8601String());
  }
}
