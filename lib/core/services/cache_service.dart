import 'package:hive_flutter/hive_flutter.dart';

import 'cached_resource.dart';

class CacheRead {
  const CacheRead(this.json, this.isStale);
  final String? json;
  final bool isStale;
}

class CacheService {
  static const _boxName = 'api_cache';
  static const _defaultTtl = Duration(hours: 24);

  late final Box<dynamic> _box;

  Future<void> init() async {
    _box = await Hive.openBox<dynamic>(_boxName);
  }

  /// Reads the cache entry without evicting expired entries (unlike [get]).
  /// Returns the stored JSON and whether the entry is past [ttl].
  CacheRead read(String key, {required Duration ttl}) {
    final entry = _box.get(key) as Map?;
    if (entry == null) return const CacheRead(null, true);
    final age =
        DateTime.now().millisecondsSinceEpoch - (entry['t'] as int);
    return CacheRead(entry['d'] as String, age > ttl.inMilliseconds);
  }

  /// Returns the cached JSON string, or null if missing or expired.
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
  Future<void> invalidatePrefix(String prefix) async {
    final keys = _box.keys
        .where((k) => k.toString().startsWith(prefix))
        .toList();
    await _box.deleteAll(keys);
  }

  // ── Stale-while-revalidate builders ────────────────────────────────────────

  /// Single-response SWR: caches the raw response body string.
  ///
  /// Returns a [CachedResource<T>] synchronously. If a valid (even stale)
  /// cached entry exists, [cached] is non-null. The [refresh] closure fetches
  /// fresh data, parses it, then writes the raw body to cache — meaning only
  /// valid, parseable responses are persisted.
  CachedResource<T> swr<T>({
    required String key,
    required Duration ttl,
    required Future<String> Function() fetchBody,
    required T Function(String body) parse,
  }) {
    final r = read(key, ttl: ttl);
    T? cached;
    if (r.json != null) {
      try {
        cached = parse(r.json!);
      } catch (_) {
        // Corrupted entry — treat as missing; refresh will overwrite it.
      }
    }
    return CachedResource<T>(
      cached: cached,
      isStale: r.isStale || cached == null,
      refresh: () async {
        final body = await fetchBody();
        final parsed = parse(body); // parse BEFORE caching — only valid data persists
        await set(key, body);
        return parsed;
      },
    );
  }

  /// Composed SWR: for features that aggregate multiple calls.
  ///
  /// [fetch] assembles the full result (e.g. 8 parallel topic fetches).
  /// [encode]/[decode] handle JSON round-tripping for the assembled type.
  CachedResource<T> swrComposed<T>({
    required String key,
    required Duration ttl,
    required Future<T> Function() fetch,
    required String Function(T) encode,
    required T Function(String) decode,
  }) {
    final r = read(key, ttl: ttl);
    T? cached;
    if (r.json != null) {
      try {
        cached = decode(r.json!);
      } catch (_) {
        // Corrupted entry — treat as missing.
      }
    }
    return CachedResource<T>(
      cached: cached,
      isStale: r.isStale || cached == null,
      refresh: () async {
        final value = await fetch();
        await set(key, encode(value));
        return value;
      },
    );
  }
}
