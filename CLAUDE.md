# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # install / sync dependencies
flutter analyze          # lint (uses flutter_lints)
flutter test             # run tests
flutter test test/path/to/widget_test.dart   # run a single test file
flutter run              # run on connected device/emulator
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

Tab-level BLoCs (`CosmoDailyBloc`, `SkyStoriesBloc`, etc.) are created inside `HomeView`'s static `screens` list via `BlocProvider(create: (_) => sl<XBloc>(), child: XPage())`. They are scoped to the page widget, not global. `AuthBloc` and `ProfileBloc` are the exceptions — `AuthBloc` is global (root), `ProfileBloc` is provided inside `HomeView` for the profile tab.

### Features overview

| Feature | Data source | Notes |
|---|---|---|
| `cosmo_daily` | NASA APOD REST API | Shares `ApodEntity` with `sky_stories` |
| `sky_stories` | NASA APOD REST API | Reuses `ApodRemoteDataSource` from cosmo_daily |
| `vintage_space` | NASA Image Library API | Parallel `Future.wait` fetch |
| `explore` | Static in-memory data | Planets + articles bundled in `explore_local_datasource.dart` |
| `profile` | Firestore `users/{uid}` | `UserEntity` has `copyWith`; shared with `auth` |
| `auth` | Firebase Auth + Firestore | `AuthBloc` subscribes to `authStateChanges()` stream on construction |

### Error handling

Datasources throw typed exceptions (`ServerException`, `AuthException`) from `core/error/exceptions.dart`. BLoCs catch these with `on<SpecificException>` and emit an error state with a message string. No `Either`/`dartz`.

### Shared assets

`lib/app/widgets/` contains shared widgets (`ExpandableText`, `Button`, `InputText`, `CustomContainer`, etc.) still used by feature pages. `lib/app/constants/colors.dart` defines `primaryColor` and `secondaryColor`. Both are intentionally kept in `lib/app/` — do not move them without updating all feature-page imports.
