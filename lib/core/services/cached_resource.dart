/// Carries an optional cached value alongside a refresher closure.
/// The BLoC can emit the cached value instantly, then await refresh() for fresh data.
class CachedResource<T> {
  const CachedResource({
    this.cached,
    required this.isStale,
    required this.refresh,
  });

  /// The parsed cached value, or null if no valid cache exists.
  final T? cached;

  /// True when the cache is missing, corrupted, or past its TTL.
  /// A stale resource with a non-null [cached] value should emit the cache
  /// immediately, then call [refresh] in the background.
  final bool isStale;

  /// Fetches fresh data from the network and overwrites the cache on success.
  /// Throws on network or parse failure — the caller should catch and decide
  /// whether to surface an error (only if [cached] is also null).
  final Future<T> Function() refresh;

  /// Maps the cached value and wraps the refresh so entity conversion happens
  /// in both paths (cache hit and network fetch) with a single function [f].
  CachedResource<R> map<R>(R Function(T) f) => CachedResource<R>(
        cached: cached == null ? null : f(cached as T),
        isStale: isStale,
        refresh: () async => f(await refresh()),
      );
}
