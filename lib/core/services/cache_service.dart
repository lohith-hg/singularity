import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static const _boxName = 'api_cache';
  static const _defaultTtl = Duration(hours: 24);

  late final Box<dynamic> _box;

  Future<void> init() async {
    _box = await Hive.openBox<dynamic>(_boxName);
  }

  /// Returns the cached JSON string, or null if missing or expired.
  /// Override [ttl] per call site if a shorter or longer window is needed.
  String? get(String key, {Duration ttl = _defaultTtl}) {
    final entry = _box.get(key) as Map?;
    if (entry == null) return null;
    final cachedAt = entry['t'] as int;
    if (DateTime.now().millisecondsSinceEpoch - cachedAt > ttl.inMilliseconds) {
      _box.delete(key);
      return null;
    }
    return entry['d'] as String;
  }

  /// Stores [json] under [key] with the current timestamp.
  Future<void> set(String key, String json) async {
    await _box.put(key, <String, dynamic>{
      'd': json,
      't': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Removes a single cached entry.
  Future<void> invalidate(String key) => _box.delete(key);

  /// Removes all entries whose key starts with [prefix].
  /// Useful for purging an entire feature's cache (e.g. 'mars_rover_').
  Future<void> invalidatePrefix(String prefix) async {
    final keys = _box.keys
        .where((k) => k.toString().startsWith(prefix))
        .toList();
    await _box.deleteAll(keys);
  }
}
