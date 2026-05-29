# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # install / sync dependencies
flutter analyze          # lint (uses flutter_lints)
flutter test             # run tests
flutter test test/path/to/widget_test.dart   # run a single test file
flutter run              # run on connected device/emulator
flutter run --dart-define=NASA_API_KEY=<your_key>   # run with custom NASA API key
flutter build apk        # Android release build
flutter build ios        # iOS release build
```

## Architecture

The app is a completed BLoC + Clean Architecture migration from GetX. State management is `flutter_bloc`, DI is `get_it`, routing is `go_router`.

### Folder layout

```
lib/
  features/<feature>/       ← all business logic lives here
    data/
      datasources/          ← raw data access (Firebase, HTTP, static)
      models/               ← fromJson/toJson wrappers around entities
      repositories/         ← concrete implementations
    domain/
      entities/             ← plain Dart classes, no serialisation
      repositories/         ← abstract interfaces
      usecases/             ← one public call() per class
    presentation/
      bloc/                 ← <feature>_bloc.dart, _event.dart, _state.dart
      pages/                ← Flutter widgets
  core/
    constants/              ← colours, topics, API URLs
    network/api_client.dart ← shared HTTP wrapper (15s timeout, retry on 429/5xx)
    services/               ← CacheService (Hive/TTL), OnboardingService (SharedPrefs)
    theme/                  ← AppColors, AppTypography, AppSpacing, AppRadii, AppTheme
    error/exceptions.dart   ← typed exceptions (ServerException, AuthException, …)
    router/app_router.dart  ← GoRouter config + auth guard
    usecases/usecase.dart   ← UseCase<Type, Params> base + NoParams
  app/
    modules/home/views/     ← HomeView shell (bottom nav, BLoC-based tabs)
    widgets/                ← shared stateless widgets used across features
    constants/              ← legacy colour/URL constants (also in core/)
  injection_container.dart  ← GetIt registration, call initDependencies() once
  main.dart                 ← Firebase init → initDependencies() → runApp()
```

### Design system

All UI uses the deep-space design system in `core/theme/`. Do not use raw colours or `Theme.of(context)` for background/text/surface — use `AppColors` constants:

```dart
AppColors.void_    // deepest background (#050507)
AppColors.ink      // standard background (#0A0A0F)
AppColors.bone     // primary text (#F4F2EE)
AppColors.signal   // amber accent (#E8C26E)
AppColors.danger   // red (#D9665A)
AppColors.good     // green (#7FB069)
```

`AppSpacing` (sp4…sp64) and `AppRadii` are used for all padding/border-radius values. Custom font is **Geist** (300–700); `AppTypography` has named text styles.

### Core services

**`ApiClient`** (`core/network/api_client.dart`): shared HTTP wrapper used by all remote datasources. Handles 15s timeout, 1 automatic retry on 429/5xx, and maps status codes to `ServerException` messages. NASA API key is read via `NasaApi.apiKey` which picks up `--dart-define=NASA_API_KEY=…` or falls back to a bundled demo key.

**`CacheService`** (`core/services/cache_service.dart`): Hive-backed TTL cache initialised before `runApp`. Default TTL is 24h; per-call override available. Use `invalidatePrefix('feature_')` to purge a feature's entire cache. Registered as a singleton via `sl<CacheService>()`.

### Dependency injection

All registrations are in `injection_container.dart`. The global locator is `sl`. Pattern: datasource → repository → usecases → bloc, always in that order per feature. BLoCs are `registerFactory` (new instance each time); everything else is `registerLazySingleton`.

```dart
sl<CosmoDailyBloc>()   // creates a fresh BLoC
sl<ApodRepository>()   // returns the singleton
```

### Routing and auth guard

`lib/core/router/app_router.dart` defines the two top-level routes (`/auth`, `/home`) and an `_AuthRefreshStream` that wraps `FirebaseAuth.instance.authStateChanges()`. GoRouter's `refreshListenable` calls the redirect on every Firebase auth event — no manual navigation is needed; sign-in and sign-out redirect automatically.

`AuthBloc` is provided once at the root (above `MaterialApp.router`) so it is accessible from both `/auth` and `/home`.

### BLoC scoping

HomeView has 5 tabs: **Cosmo Daily → Explore → Tracker → Mars Rover → Profile**. The Tracker tab is a nested `StatefulWidget` (`TrackerPage`) with two sub-tabs: *ISS* and *Earth (EPIC)*.

Each tab's BLoC is created inside `HomeView.initState` via `BlocProvider(create: (_) => sl<XBloc>(), child: XPage())`, scoped to the page. `SavedBloc` is provided at `HomeView` level (not a nav tab). `AuthBloc` is global (root). `ProfileBloc` is provided inside `HomeView`.

### Features overview

| Feature | Data source | Notes |
|---|---|---|
| `cosmo_daily` | NASA APOD REST API | `ApodEntity` lives in `features/shared/entities/` |
| `vintage_space` | NASA Image Library API | Parallel `Future.wait` fetch |
| `explore` | Static in-memory data | Planets + articles bundled in `explore_local_datasource.dart` |
| `profile` | Firestore `users/{uid}` | `UserEntity` has `copyWith`; shared with `auth` |
| `auth` | Firebase Auth + Firestore | `AuthBloc` subscribes to `authStateChanges()` stream on construction |
| `mars_rover` | NASA Mars Rover Photos API | Photos per rover/sol; uses `CacheService` (24h TTL) |
| `epic` | NASA EPIC API | Earth imagery; embedded in Tracker tab (Earth sub-tab) |
| `iss_tracker` | Open Notify API | Live ISS position; embedded in Tracker tab (ISS sub-tab) |
| `neo` | NASA NeoWs API | Near-Earth object data |
| `exoplanets` | NASA Exoplanet Archive TAP | SQL-like TAP/sync endpoint |
| `donki` | NASA DONKI API | Space weather events |
| `saved` | Firestore `users/{uid}/saved` | Saved APODs; `SavedBloc` global within `HomeView` |

### Error handling

Datasources throw typed exceptions (`ServerException`, `AuthException`) from `core/error/exceptions.dart`. BLoCs catch these with `on<SpecificException>` and emit an error state with a message string. No `Either`/`dartz`.

### Shared assets

`lib/app/widgets/` contains the `S`-prefixed design system widgets used across all feature pages: `SNavBar`, `SInput`, `STile`, `SButton`, `SRoundBtn`, `SChip`, `STabBar`, `SingularityLogo`, `ScrimWidget`. Do not move or rename these without updating all feature-page imports.

`lib/app/constants/colors.dart` still exports `primaryColor`/`secondaryColor` for legacy callers — prefer `AppColors` from `core/theme/app_colors.dart` in new code.
