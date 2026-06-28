# Caching Progress — Stale-While-Revalidate Implementation

Update each step: `[ ]` → `[~]` in progress → `[x]` done.

## Steps

- [x] 0. Created this file
- [x] 1. `lib/core/services/cached_resource.dart` — new CachedResource<T> class
- [x] 2. `lib/core/services/cache_service.dart` — add CacheRead, read(), swr(), swrComposed()
- [x] 3. **cosmo_daily**: datasource → repo → usecase → bloc (swr, 12h TTL, gallery shuffle)
- [x] 4. **epic**: refactor fallback, swr (12h TTL), gallery shuffle
- [x] 5. **neo**: swr (12h TTL), keep date sort, key includes startDate
- [x] 6. **exoplanets**: swr (7d TTL), keep year sort, refresh _allPlanets + re-filter
- [x] 7. **vintage_space**: add HistoryAlbumModel.toJson/fromCached, swrComposed (24h TTL), gallery shuffle
- [x] 8. **donki**: add SpaceWeatherEventModel.toJson/fromCached, swrComposed (12h TTL), keep time sort
- [x] 9. **mars_rover**: migrate datasource to swr (fixes cache-before-parse bug), SWR two-emit in _onLoadAll
- [x] 10. `injection_container.dart` — pass cacheService: sl() to 6 datasources
- [x] 11. flutter analyze: 0 issues; flutter test: 17/17 pass
- [ ] 12. Manual end-to-end verification (run app, confirm spinner only on first launch)

## Key patterns

### Datasource (swr, single response)
```dart
CachedResource<List<XModel>> getX() {
  return (_cache ?? _noopSwr()).swr(
    key: 'x_key', ttl: const Duration(hours: 12),
    fetchBody: () async => (await _apiClient.get(uri, label: 'X')).body,
    parse: xListFromJson,
  );
}
```

### BLoC (two-emit SWR, gallery features shuffle)
```dart
Future<void> _onLoad(Event e, Emitter emit) async {
  final res = await useCase(params);
  final cached = res.cached;
  if (cached != null) emit(XLoaded(items: _shuffled(cached)));  // instant
  else emit(const XLoading());
  if (res.isStale) {
    try { emit(XLoaded(items: _shuffled(await res.refresh()))); }
    on ServerException catch (ex) { if (cached == null) emit(XError(ex.message)); }
    catch (ex) { if (cached == null) emit(XError(ex.toString())); }
  }
}
```

Data features (neo, donki, exoplanets) use same pattern but sort instead of shuffle.
