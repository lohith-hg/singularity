# Singularity — Astronomy Facts

A production Flutter app for exploring astronomy content: NASA's Astronomy Picture of the Day, historical NASA imagery, solar system data, and universe theory articles. The codebase was fully migrated from GetX MVC to **BLoC + Clean Architecture**, making it a practical reference for scalable Flutter application design.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Dart (SDK `>=2.19.1`) |
| Framework | Flutter |
| State management | `flutter_bloc` 8.x / `bloc` 8.x |
| Dependency injection | `get_it` |
| Navigation | `go_router` |
| Backend | Firebase Auth + Cloud Firestore |
| HTTP | `dart:io` via `Uri.https` / `http` package |
| Auth providers | Email/password, Google Sign-In |

---

## Architecture

The app follows **Clean Architecture** with a **feature-first** folder structure. Every feature is self-contained across three layers: `data`, `domain`, and `presentation`.

```
lib/
  features/
    auth/
    cosmo_daily/
    explore/
    profile/
    sky_stories/
    vintage_space/
    shared/             ← entities shared across features (ApodEntity)
  core/
    constants/
    error/
    router/
    usecases/
  app/
    modules/home/       ← app shell (bottom navigation)
    widgets/            ← shared UI components
    constants/
  injection_container.dart
  main.dart
```

### Layer responsibilities

**Domain layer** — pure Dart, no Flutter or Firebase imports.
- `entities/` — plain data classes with no serialisation logic
- `repositories/` — abstract interfaces the data layer must satisfy
- `usecases/` — single-responsibility classes; each exposes one `call()` method

**Data layer** — implements the domain contracts.
- `datasources/` — talks directly to Firebase / REST APIs; throws typed exceptions
- `models/` — extend entities with `fromJson`/`toJson`; handle null-safety for API responses
- `repositories/` — catch datasource exceptions, convert to domain types, return results

**Presentation layer**
- `bloc/` — receives events, calls usecases, emits states; no business logic in widgets
- `pages/` — `BlocBuilder`/`BlocConsumer` widgets; pure UI

---

## State Management — BLoC

Each feature has its own BLoC with co-located event and state files via Dart `part` directives:

```
cosmo_daily_bloc.dart   ← class CosmoDailyBloc extends Bloc<…>
cosmo_daily_event.dart  ← sealed event hierarchy
cosmo_daily_state.dart  ← sealed state hierarchy
```

States are `Equatable` subclasses, which means `BlocBuilder` only rebuilds on distinct state changes. Events are dispatched with `context.read<XBloc>().add(XEvent())`.

**BLoC scoping strategy:**

- `AuthBloc` — provided once at the app root (above `MaterialApp.router`) so auth state is globally accessible.
- Tab BLoCs (`CosmoDailyBloc`, `SkyStoriesBloc`, `VintageSpaceBloc`, `ExploreBloc`, `ProfileBloc`) — each wrapped in its own `BlocProvider` inside `HomeView`. They are created on first tab visit and disposed when the shell is destroyed.

---

## Dependency Injection — GetIt

All registrations live in `injection_container.dart`. The `sl` global locator is the single access point.

```dart
// datasource → repository → usecase → bloc, always in this order
sl.registerLazySingleton<ApodRemoteDataSource>(() => ApodRemoteDataSourceImpl());
sl.registerLazySingleton<ApodRepository>(() => ApodRepositoryImpl(sl()));
sl.registerLazySingleton(() => GetApodPictures(sl()));
sl.registerFactory(() => CosmoDailyBloc(getApodPictures: sl()));
```

- **`registerLazySingleton`** — datasources, repositories, usecases. Created once, reused.
- **`registerFactory`** — BLoCs. A fresh instance is created each time the tab is mounted, ensuring clean state on re-entry.

`sky_stories` deliberately reuses the `ApodRemoteDataSource` singleton already registered by `cosmo_daily` — they hit the same NASA API endpoint and share the `ApodEntity`.

---

## Navigation — GoRouter with Auth Guard

`lib/core/router/app_router.dart` defines two top-level routes: `/auth` and `/home`.

Authentication-driven redirection is handled by `_AuthRefreshStream`, a `ChangeNotifier` that wraps `FirebaseAuth.instance.authStateChanges()`:

```dart
refreshListenable: _AuthRefreshStream(FirebaseAuth.instance.authStateChanges()),
redirect: (context, state) {
  final isLoggedIn = FirebaseAuth.instance.currentUser != null;
  if (!isLoggedIn && state.matchedLocation != '/auth') return '/auth';
  if (isLoggedIn  && state.matchedLocation == '/auth') return '/home';
  return null;
},
```

Whenever Firebase fires an auth event (sign-in or sign-out), `notifyListeners()` is called, GoRouter re-evaluates the redirect, and navigation happens without any imperative `Navigator.push` or `context.go()` calls in the BLoC or widget layer.

---

## Data Flow — End to End

Taking `CosmoDailyPage` loading pictures as an example:

```
CosmoDailyPage.initState()
  └── context.read<CosmoDailyBloc>().add(LoadCosmoDailyEvent())
        └── CosmoDailyBloc._onLoad()
              └── GetApodPictures.call(ApodParams(...))         ← usecase
                    └── ApodRepositoryImpl.getApodPictures()   ← repository
                          └── ApodRemoteDataSourceImpl.fetch() ← datasource
                                └── http GET nasa.gov/apod
              emit(CosmoDailyLoaded(pictures))
        └── BlocBuilder rebuilds → PageView of pictures
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

This means the BLoC is always in sync with Firebase, even if a session expires or is revoked externally. Sign-in and sign-up usecases only call the Firebase API — they do not emit `AuthAuthenticated` directly. The stream fires, `AuthStateChangedEvent` is added, and the BLoC emits the correct state. GoRouter's `_AuthRefreshStream` then picks up the Firebase event and redirects.

Sign-out dispatches `SignOutEvent` → `SignOutUseCase` → `FirebaseAuth.signOut()` → stream fires → `AuthUnauthenticated` → GoRouter redirects to `/auth`.

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

The `field` on `AuthError` lets the UI attach inline validation errors to the specific form field (email vs password) rather than showing a generic snackbar.

---

## Key Design Decisions

**Why Clean Architecture?**
The domain layer has zero framework dependencies. Usecases and entities can be unit-tested without Firebase, HTTP, or Flutter. Swapping the data source (e.g., replacing REST with GraphQL, or Firebase with Supabase) only touches `data/` — the BLoC and UI are unaffected.

**Why BLoC over Provider/Riverpod?**
BLoC enforces a strict unidirectional data flow: events in, states out. The explicit event/state split makes it easy to audit exactly what triggers a UI change and to reproduce bugs deterministically. It also makes the presentation layer easy to test by simply pumping events and asserting emitted states.

**Why GetIt over BlocProvider-based injection?**
`BlocProvider` is used for _scoping_ BLoCs to the widget tree. GetIt is used for _construction_ — it holds the graph of datasources, repositories, and usecases that BLoCs depend on. Separating these concerns means the DI graph can be fully constructed before `runApp()` and tested independently.

**Shared `ApodEntity`**
`CosmoDaily` (APOD pictures) and `SkyStories` (APOD-based stories) both consume the same NASA endpoint. Rather than duplicating the model, `ApodEntity` lives in `lib/features/shared/entities/` and both features reference it. The datasource (`ApodRemoteDataSource`) is registered once and injected into both repositories.

---

## Running Locally

```bash
flutter pub get
flutter run
```

Firebase is pre-configured via `lib/firebase_options.dart` (generated by FlutterFire CLI). Google Sign-In requires a valid `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) in the platform directories.
