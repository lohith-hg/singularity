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
    services/               ← CacheService (Hive/TTL + SWR), CachedResource, GuestSession, OnboardingService (SharedPrefs)
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

**`CacheService`** (`core/services/cache_service.dart`): Hive-backed cache initialised before `runApp`, registered as a singleton via `sl<CacheService>()`. `read(key, ttl)` returns a `CacheRead` (cached JSON + an `isStale` flag). On top of that it exposes **stale-while-revalidate** helpers — `swr<T>(...)` (single response) and `swrComposed<T>(...)` (several responses merged) — which return a `CachedResource<T>` (`core/services/cached_resource.dart`). Use `invalidatePrefix('feature_')` to purge a feature's cache.

**SWR pattern (all NASA features):** remote datasources return a `CachedResource<T>`, not a raw `Future`. The BLoC emits the cached value instantly if present, then emits again with fresh data once the background refresh resolves — so the loading spinner only appears on first launch. Per-feature TTLs range 12h–7d.

### Dependency injection

All registrations are in `injection_container.dart`. The global locator is `sl`. Pattern: datasource → repository → usecases → bloc, always in that order per feature. BLoCs are `registerFactory` (new instance each time); everything else is `registerLazySingleton`.

```dart
sl<CosmoDailyBloc>()   // creates a fresh BLoC
sl<ApodRepository>()   // returns the singleton
```

### Routing and auth guard

`lib/core/router/app_router.dart` defines all routes: auth screens (`/splash`, `/onboarding`, `/login`, `/signup`, `/forgot`), the tab shell (`/home`), and the secondary feature routes (`/mars`, `/epic`, `/iss`, `/neo`, `/exoplanets`, `/donki`, `/library`, `/search`, `/saved`, `/apod-detail`, `/privacy`).

The guard is GoRouter's `redirect` + a `refreshListenable` that **merges two `ChangeNotifier`s**: `_AuthRefreshStream` (wraps `FirebaseAuth.instance.authStateChanges()`) and `GuestSession` (`core/services/guest_session.dart`, a singleton "browse without an account" flag). `/home` is allowed when the user is logged in **or** a guest; sign-in/out and toggling guest mode redirect automatically — no manual navigation.

`AuthBloc` is provided once at the root (above `MaterialApp.router`) so it is accessible everywhere.

### BLoC scoping

HomeView has 4 tabs: **Today (`CosmoDailyPage`) → Mars (`MarsRoverPage`) → Vault (`VintageSpacePage`, embedded) → Me (`ProfilePage`)** — an `IndexedStack` driven by `SNavBar`. Each tab's BLoC is created in `HomeView.initState` via `BlocProvider(create: (_) => sl<XBloc>(), child: XPage())`, scoped to the page. `SavedBloc` is provided at the `HomeView` root (used by both Profile's stats and the `/saved` page). `AuthBloc` is global (root).

The other NASA features (NEO, DONKI, Exoplanets, EPIC, ISS) are **not** tabs — they are pushed `go_router` routes, each scoping its BLoC in the `GoRoute` builder.

### Features overview

| Feature | Data source | Notes |
|---|---|---|
| `cosmo_daily` | NASA APOD REST API | **Today** tab; `ApodEntity` in `features/shared/entities/`. Video APODs play **inline** in `apod_detail_page` (`youtube_player_iframe`, with a `webview_flutter` fallback for non-YouTube embeds) |
| `mars_rover` | NASA Image & Video Library — `images-api.nasa.gov/search?q=<rover> rover mars` | **Mars** tab. **Not** the Mars Rover Photos API; it's a keyword search, so results include non-surface imagery. 24h SWR cache |
| `vintage_space` | NASA Image Library API | **Vault** tab (the Archive); parallel `Future.wait` over random topics. Cards open `vintage_image_detail_page` |
| `profile` | Firestore `users/{uid}` | **Me** tab; `UserEntity` has `copyWith`; shared with `auth` |
| `auth` | Firebase Auth + Firestore | `AuthBloc` subscribes to `authStateChanges()` on construction; guest mode via `GuestSession` |
| `epic` | NASA EPIC API | Earth imagery; standalone `/epic` route (`embedded` flag retained) |
| `iss_tracker` | Open Notify API | Live ISS position; standalone `/iss` route |
| `neo` | NASA NeoWs API | Near-Earth objects; `/neo` route |
| `exoplanets` | NASA Exoplanet Archive TAP | SQL-like TAP/sync endpoint; `/exoplanets` route |
| `donki` | NASA DONKI API | Space weather events; `/donki` route |
| `saved` | Firestore `users/{uid}/saved` | Saved APODs; `SavedBloc` global within `HomeView` |

### Error handling

Datasources throw typed exceptions (`ServerException`, `AuthException`) from `core/error/exceptions.dart`. BLoCs catch these with `on<SpecificException>` and emit an error state with a message string. No `Either`/`dartz`.

### Shared assets

`lib/app/widgets/` contains the `S`-prefixed design system widgets used across all feature pages: `SNavBar`, `SInput`, `STile`, `SButton`, `SRoundBtn`, `SChip`, `STabBar`, `SingularityLogo`, `ScrimWidget`. Do not move or rename these without updating all feature-page imports.

`lib/app/constants/colors.dart` still exports `primaryColor`/`secondaryColor` for legacy callers — prefer `AppColors` from `core/theme/app_colors.dart` in new code.
