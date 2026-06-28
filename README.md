# Singularity — A Window on the Universe

A production Flutter app for exploring space through free public APIs: NASA's Astronomy Picture of the Day, Mars and Earth imagery, near-Earth asteroids, exoplanets, space weather, live ISS position, and the NASA image library. The codebase is a **BLoC + Clean Architecture** build (migrated from GetX MVC), with a stale-while-revalidate caching layer — a practical reference for scalable Flutter application design.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Dart (SDK `>=3.10.0 <4.0.0`) |
| Framework | Flutter |
| State management | `flutter_bloc` 9.x / `bloc` 9.x |
| Dependency injection | `get_it` |
| Navigation | `go_router` |
| Local cache | `hive` / `hive_flutter` (TTL + stale-while-revalidate) |
| Backend | Firebase Auth + Cloud Firestore |
| HTTP | `http` package via a shared `ApiClient` (`Uri.https`) |
| Auth | Email/password, Google Sign-In, and guest mode |
| Media | `youtube_player_iframe` + `webview_flutter` (inline video APODs) |

Data comes from free NASA/astronomy APIs (APOD, Mars Rover, EPIC, NeoWs, Exoplanet Archive TAP, DONKI, Image Library, Open Notify ISS).

---

## Architecture

The app follows **Clean Architecture** with a **feature-first** folder structure. Every feature is self-contained across three layers: `data`, `domain`, and `presentation`.

```
lib/
  features/
    auth/             cosmo_daily/      mars_rover/
    vintage_space/    epic/             iss_tracker/
    neo/              exoplanets/       donki/
    profile/          saved/
    shared/           ← entities shared across features (ApodEntity)
  core/
    constants/        ← colours, topics, NASA API URLs + key
    network/          ← ApiClient (15s timeout, retry on 429/5xx)
    services/         ← CacheService, CachedResource, GuestSession, OnboardingService
    error/            ← typed exceptions (ServerException, AuthException)
    router/           ← GoRouter config + auth guard
    theme/            ← AppColors, AppTypography, AppSpacing, AppRadii
    usecases/         ← UseCase<Type, Params> base + NoParams
  app/
    modules/home/     ← HomeView shell (4-tab bottom navigation)
    widgets/          ← shared S-prefixed UI components
    constants/
  injection_container.dart
  main.dart           ← Firebase init → initDependencies() → runApp()
```

### Layer responsibilities

**Domain layer** — pure Dart, no Flutter or Firebase imports.
- `entities/` — plain data classes with no serialisation logic
- `repositories/` — abstract interfaces the data layer must satisfy
- `usecases/` — single-responsibility classes; each exposes one `call()` method

**Data layer** — implements the domain contracts.
- `datasources/` — talk to Firebase / REST APIs; throw typed exceptions. NASA datasources return a `CachedResource<T>` (see Caching) rather than a raw `Future`
- `models/` — extend entities with `fromJson`/`toJson`; handle null-safety for API responses
- `repositories/` — adapt datasource results to domain types

**Presentation layer**
- `bloc/` — receives events, calls usecases, emits states; no business logic in widgets
- `pages/` — `BlocBuilder`/`BlocConsumer` widgets; pure UI

---

## Features

| Feature | Surface | Data source |
|---|---|---|
| `cosmo_daily` | **Today** tab | NASA APOD REST API. Video APODs play **inline** (`youtube_player_iframe`, with a `webview_flutter` fallback) |
| `mars_rover` | **Mars** tab | NASA Image & Video Library keyword search (`images-api.nasa.gov`) |
| `vintage_space` | **Vault** tab | NASA Image Library (random topics, parallel fetch) |
| `profile` | **Me** tab | Firestore `users/{uid}` |
| `auth` | Auth screens | Firebase Auth + Firestore; email/password, Google, guest |
| `epic` | `/epic` route | NASA EPIC (Earth imagery) |
| `iss_tracker` | `/iss` route | Open Notify (live ISS position) |
| `neo` | `/neo` route | NASA NeoWs (near-Earth objects) |
| `exoplanets` | `/exoplanets` route | NASA Exoplanet Archive TAP |
| `donki` | `/donki` route | NASA DONKI (space weather) |
| `saved` | `/saved` route | Firestore `users/{uid}/saved` (bookmarked APODs) |

The four bottom-nav tabs are **Today → Mars → Vault → Me**; the remaining NASA features are pushed `go_router` routes.

---

## State Management — BLoC

Each feature has its own BLoC with co-located event and state files via Dart `part` directives:

```
cosmo_daily_bloc.dart   ← class CosmoDailyBloc extends Bloc<…>
cosmo_daily_event.dart  ← sealed event hierarchy   (part of bloc.dart)
cosmo_daily_state.dart  ← sealed state hierarchy    (part of bloc.dart)
```

States are `Equatable` subclasses, so `BlocBuilder` only rebuilds on distinct state changes. Events are dispatched with `context.read<XBloc>().add(XEvent())`.

**BLoC scoping strategy:**

- `AuthBloc` — provided once at the app root (above `MaterialApp.router`) so auth state is globally accessible.
- Tab BLoCs (`CosmoDailyBloc`, `MarsRoverBloc`, `VintageSpaceBloc`, `ProfileBloc`) — each wrapped in its own `BlocProvider` inside `HomeView`, scoped to the page. `SavedBloc` is provided at the `HomeView` root (shared by Profile's stats and the `/saved` page).
- Routed feature BLoCs (`NeoBloc`, `DonkiBloc`, `ExoplanetsBloc`, `EpicBloc`, `IssTrackerBloc`) — created in their `GoRoute` builder.

---

## Dependency Injection — GetIt

All registrations live in `injection_container.dart`. The `sl` global locator is the single access point.

```dart
// datasource → repository → usecase → bloc, always in this order
sl.registerLazySingleton<ApodRemoteDataSource>(
  () => ApodRemoteDataSourceImpl(cacheService: sl()));
sl.registerLazySingleton<ApodRepository>(() => ApodRepositoryImpl(sl()));
sl.registerLazySingleton(() => GetApodPictures(sl()));
sl.registerFactory(() => CosmoDailyBloc(getApodPictures: sl()));
```

- **`registerLazySingleton`** — datasources, repositories, usecases, and shared services (`CacheService`, `GuestSession`). Created once, reused.
- **`registerFactory`** — BLoCs. A fresh instance each time, ensuring clean state on re-entry.

`CacheService` is injected into each NASA datasource so responses are cached and revalidated transparently.

---

## Caching — Stale-While-Revalidate

`CacheService` (`core/services/cache_service.dart`) is a Hive-backed cache initialised before `runApp`. Beyond plain `read(key, ttl)` (returns a `CacheRead` with the cached JSON + an `isStale` flag) it exposes SWR helpers — `swr<T>(...)` and `swrComposed<T>(...)` — that return a `CachedResource<T>`.

```
NASA datasource ──► CachedResource<T> { cached, isStale, refresh() }
        │
BLoC:  emit cached value instantly (if present)
        └── if stale → await refresh() → emit fresh value
```

The loading spinner therefore appears only on first launch; subsequent visits render cached data immediately and update in the background. Per-feature TTLs range from 12 hours to 7 days. `invalidatePrefix('feature_')` purges a feature's cache.

---

## Navigation — GoRouter with Auth Guard

`lib/core/router/app_router.dart` defines the auth screens (`/splash`, `/onboarding`, `/login`, `/signup`, `/forgot`), the tab shell (`/home`), and the secondary routes (`/mars`, `/epic`, `/iss`, `/neo`, `/exoplanets`, `/donki`, `/library`, `/search`, `/saved`, `/apod-detail`, `/privacy`).

The guard is GoRouter's `redirect` plus a `refreshListenable` that **merges two `ChangeNotifier`s** — `_AuthRefreshStream` (wraps `FirebaseAuth.instance.authStateChanges()`) and `GuestSession` (a "browse without an account" flag):

```dart
refreshListenable: Listenable.merge([
  _AuthRefreshStream(FirebaseAuth.instance.authStateChanges()),
  sl<GuestSession>(),
]),
redirect: (context, state) {
  final isLoggedIn = FirebaseAuth.instance.currentUser != null;
  final isGuest = sl<GuestSession>().isActive;
  final loc = state.matchedLocation;
  if (loc == '/splash' || loc == '/onboarding') return null;
  if (!isLoggedIn && !isGuest && loc == '/home') return '/login';
  if (isLoggedIn && (loc == '/login' || loc == '/signup')) return '/home';
  return null;
},
```

Whenever Firebase fires an auth event or guest mode toggles, `notifyListeners()` runs, GoRouter re-evaluates the redirect, and navigation happens without any imperative `Navigator.push`/`context.go()` in the BLoC or widget layer.

---

## Data Flow — End to End

Taking `CosmoDailyPage` loading pictures as an example:

```
CosmoDailyPage.initState()
  └── context.read<CosmoDailyBloc>().add(LoadCosmoDailyEvent())
        └── CosmoDailyBloc._onLoad()
              └── GetApodPictures.call(...)               ← usecase
                    └── ApodRepositoryImpl.getApodPictures()  ← repository
                          └── ApodRemoteDataSourceImpl       ← datasource
                                └── CacheService.swr(...) → CachedResource
              emit(CosmoDailyLoaded(cached))               ← instant, if cached
              if stale: emit(CosmoDailyLoaded(fresh))      ← after refresh
        └── BlocBuilder rebuilds
```

Errors propagate upward as typed exceptions (`ServerException`) caught at the BLoC level, which emits an error state rendered as a message in the UI.

---

## Authentication Flow

`AuthBloc` subscribes to Firebase's `authStateChanges()` stream immediately on construction:

```dart
_authSub = getAuthState(NoParams()).listen(
  (user) => add(AuthStateChangedEvent(user)),
);
```

The BLoC is always in sync with Firebase, even if a session expires or is revoked externally. Sign-in/sign-up usecases only call the Firebase API — they do not emit `AuthAuthenticated` directly. The stream fires, `AuthStateChangedEvent` is added, the BLoC emits the correct state, and GoRouter's guard redirects.

Sign-out dispatches `SignOutEvent` → `FirebaseAuth.signOut()` → stream fires → `AuthUnauthenticated` → GoRouter redirects to `/login`. Guest users browse via `GuestSession` without a Firebase account.

---

## Error Handling

Datasources throw from a small set of typed exceptions in `core/error/exceptions.dart`:

```dart
class ServerException implements Exception { final String message; }
class AuthException  implements Exception { final String message; final String? code; }
```

BLoCs map exceptions to error states:

```dart
} on AuthException catch (e) {
  emit(AuthError(message: e.message, field: _fieldFromCode(e.code)));
} catch (e) {
  emit(AuthError(message: e.toString()));
}
```

The `field` on `AuthError` lets the UI attach inline validation errors to the specific form field (email vs password) rather than a generic snackbar.

---

## Key Design Decisions

**Why Clean Architecture?**
The domain layer has zero framework dependencies. Usecases and entities can be unit-tested without Firebase, HTTP, or Flutter. Swapping a data source only touches `data/` — the BLoC and UI are unaffected.

**Why BLoC over Provider/Riverpod?**
BLoC enforces strict unidirectional data flow: events in, states out. The explicit event/state split makes it easy to audit what triggers a UI change and to reproduce bugs deterministically, and makes the presentation layer easy to test by pumping events and asserting emitted states.

**Why GetIt over BlocProvider-based injection?**
`BlocProvider` _scopes_ BLoCs to the widget tree; GetIt _constructs_ the graph of datasources, repositories, and usecases they depend on. Separating these means the DI graph can be built before `runApp()` and tested independently.

**Why stale-while-revalidate?**
Space data changes slowly (often daily). Returning cached data instantly and refreshing in the background keeps the UI responsive offline and on slow connections, while still converging on fresh data — without per-screen loading spinners after the first visit.

---

## Running Locally

```bash
flutter pub get
flutter run

# optional: supply your own NASA API key (otherwise a bundled DEMO_KEY is used)
flutter run --dart-define=NASA_API_KEY=<your_key>
```

Firebase is pre-configured via `lib/firebase_options.dart` (generated by the FlutterFire CLI). Google Sign-In requires a valid `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) in the platform directories.

```bash
flutter analyze     # lint (flutter_lints)
flutter test        # run tests
flutter build apk   # Android release build
```
