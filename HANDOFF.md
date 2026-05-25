# Singularity — AI Agent Handoff Document

## What this project is

Singularity is a Flutter app that serves as a window on the universe — an editorial-design space app powered by 8 free NASA APIs. It was fully redesigned from a Material 3 black/orange GetX app into a deep-space monochrome editorial app using BLoC + Clean Architecture.

**Stack:** Flutter 3 · Dart · flutter_bloc · get_it · go_router · Firebase Auth + Firestore · Google Fonts

---

## What was built (all complete)

### Architecture
- **Pattern:** BLoC + Clean Architecture (data → domain → presentation) per feature
- **DI:** GetIt via `lib/injection_container.dart` — all features registered
- **Routing:** GoRouter in `lib/core/router/app_router.dart` with auth guard
- **State:** `flutter_bloc` — no GetX remaining

### Design system (`lib/core/theme/`)
- `app_colors.dart` — deep-space palette: `ink`, `bone`, `signal`, `danger`, `good`, `hairline`
- `app_spacing.dart` — sp4 through sp80 constants
- `app_theme.dart` — full ThemeData with Switch, Slider, Checkbox, AppBar styling
- Geist font (300–700) bundled locally in `assets/fonts/`
- Google Fonts: Newsreader (serif display) + JetBrains Mono (monospace)

### Shared widgets (`lib/app/widgets/`)
- `s_button.dart` — primary + ghost variants
- `s_input.dart` — underline text field with label + validation
- `s_round_btn.dart` — frosted 36px circle button
- `s_nav_bar.dart` — frosted glass 5-tab bottom nav
- `s_tab_bar.dart` — underline tab bar for Tracker sub-tabs
- `s_chip.dart` — solid/ghost pill chips for filter rows
- `scrim_widget.dart` — top + bottom gradient scrims
- `singularity_logo.dart` — custom-painted mark + Newsreader wordmark

### Auth flow (5 screens)
| Route | File | Status |
|---|---|---|
| `/splash` | `splash_page.dart` | ✅ Starfield + logo + 2.2s delay → routing |
| `/onboarding` | `onboarding_page.dart` | ✅ Hero bg + serif headline + Begin → marks onboarding complete |
| `/login` | `login_page.dart` | ✅ Email/password + Google sign-in |
| `/signup` | `signup_page.dart` | ✅ Name/email/password + terms checkbox |
| `/forgot` | `forgot_page.dart` | ✅ Email → Firebase password reset |

Onboarding seen flag stored via `shared_preferences` in `lib/core/services/onboarding_service.dart`.

### 5-tab home navigation (`lib/app/modules/home/views/home_view.dart`)
| Tab | Route | Screen |
|---|---|---|
| Today | — | `CosmoDailyPage` |
| Explore | — | `ExplorePage` (8 archive cards) |
| Tracker | — | `TrackerPage` (ISS + Earth sub-tabs) |
| Saved | — | `SavedPage` |
| Me | — | `ProfilePage` |

`SavedBloc` is provided at HomeView root so Profile's stats row and the Saved tab both read the same state.

### Features (all fully implemented with real API calls)

#### 1. Cosmo Daily (`lib/features/cosmo_daily/`)
- Fetches 8 days of APOD from NASA, sorts newest-first
- Hero (460px) + body text + 2×2 "Today across the system" grid + 7-item horizontal carousel
- Grid navigates: Mars→`/mars`, Earth→`/epic`, Space weather→`/donki`, Asteroids→`/neo`
- Tap hero or carousel item → `/apod-detail`

#### 2. APOD Detail (`lib/features/cosmo_daily/presentation/pages/apod_detail_page.dart`)
- 520px hero with back/bookmark/share buttons
- Bookmark toggles save via `SavedBloc` → Firestore `users/{uid}/saved_items/{date}`
- "Wallpaper" button downloads HD image bytes via `http` + saves to gallery via `gal`
- Video APODs hide the Wallpaper button

#### 3. Explore (`lib/features/explore/`)
- 8 archive cards with per-archive background colors and accent colors
- Each card navigates to its route: `/mars`, `/epic`, `/neo`, `/donki`, `/exoplanets`, `/library`, `/iss`
- APOD card has `route: null` (already the Today tab)

#### 4. Mars Rover (`lib/features/mars_rover/`)
- API: `https://api.nasa.gov/mars-photos/api/v1/rovers/{rover}/photos?sol={sol}`
- Rovers: Curiosity / Perseverance / Opportunity (tab switcher via `STabBar`)
- Sol scrubber (Slider → triggers re-fetch)
- 280px hero + 3-column photo grid via `CachedNetworkImage`

#### 5. EPIC Earth (`lib/features/epic/`)
- API: `https://api.nasa.gov/EPIC/api/natural/images`
- Image URL constructed from identifier + date
- 14-bar time scrubber to switch between frames
- Coordinate overlay (lat/lon/caption)
- `embedded: bool` param — used standalone (`/epic`) and embedded in Tracker tab

#### 6. ISS Tracker (`lib/features/iss_tracker/`)
- API: `https://api.open-notify.org/iss-now.json` (HTTPS — HTTP is blocked on Android 9+)
- BLoC polls every 5 seconds via `Timer.periodic` + `emit.forEach` stream pattern
- Custom `_WorldGridPainter` draws lat/lon grid; amber ISS marker positioned via screen coord conversion
- `embedded: bool` param — used standalone (`/iss`) and embedded in Tracker tab
- Bell button shows SnackBar directing user to Profile → Preferences
- "Next visible pass: Coming soon" — ISS pass prediction API is deprecated (intentional placeholder)

#### 7. NeoWs (`lib/features/neo/`)
- API: `https://api.nasa.gov/neo/rest/v1/feed` for current week Mon–Sun
- Timeline list: date column (serif day + month) + name + miss distance + diameter + hazard badge
- "TODAY" amber chip on today's entries; red "HAZARDOUS" badge on dangerous objects

#### 8. Exoplanets (`lib/features/exoplanets/`)
- API: IPAC TAP (`https://exoplanetarchive.ipac.caltech.edu/TAP/sync`) — no key needed
- Fetches top 200 planets ordered by discovery year desc
- Filter chips: All / Earth-like / Hot Jupiter / Super-Earth / Habitable
- Each row: radial-gradient planet circle (color-coded by radius) + name + distance + mass

#### 9. DONKI Space Weather (`lib/features/donki/`)
- Parallel `Future.wait` across 4 endpoints: CME, FLR, GST, SEP
- Status tile: sun icon + KP-index + ACTIVE/QUIET badge (threshold Kp > 4)
- Event list: type badge + description + UTC time

#### 10. Saved (`lib/features/saved/`)
- Firestore path: `users/{uid}/saved_items/{apodDate}` ordered by `savedAt` desc
- 2-column masonry grid of `CachedNetworkImage` thumbnails
- Empty state: bookmark icon + prompt copy
- Tap any card → `/apod-detail`

#### 11. Profile (`lib/features/profile/`)
- Avatar: 64px circle with gradient bg + serif italic initial (tappable → edit name)
- 3-stat row: Saved count (live from `SavedBloc`) / Wallpapers (0, hardcoded) / Alerts (0, hardcoded)
- Preferences section: 4 toggles stored in Firestore `users/{uid}.preferences` as `Map<String, bool>`
  - `apodDigest`, `issAlerts`, `solarAlerts`, `neoAlerts`
- Settings gear scrolls to Preferences section via `Scrollable.ensureVisible` + `GlobalKey`
- Edit profile → bottom sheet → name text field → `UpdateProfileEvent`
- About Singularity → `AlertDialog` with app info
- Sign out → `SignOutEvent` → auth guard redirects to `/login`

#### 12. Image Library (`lib/features/vintage_space/`)
- API: `https://images-api.nasa.gov` — picks 8 random topics from `core/constants/topics.dart`, parallel fetch
- Route: `/library` from Explore tab

---

## What is intentionally incomplete (known stubs)

| Location | Stub | Reason |
|---|---|---|
| Today tab hero → search button | `onPressed: () {}` | No search feature built |
| Profile → Account → Privacy row | `onTap: () {}` | No privacy policy page |
| ISS tracker bottom | "Next visible pass: Coming soon" | ISS pass prediction API is deprecated/removed |
| Profile stats | WALLPAPERS: 0 · ALERTS: 0 | No wallpaper count tracking in data model |

---

## Code health

```
flutter analyze  → No issues found
flutter build apk --debug  → ✓ Built successfully
```

Zero errors, zero warnings, zero lint hints (all `prefer_const_constructors` fixed via `dart fix --apply`).

---

## Key files for orientation

| File | Purpose |
|---|---|
| `lib/injection_container.dart` | All GetIt registrations |
| `lib/core/router/app_router.dart` | All routes + auth guard |
| `lib/app/modules/home/views/home_view.dart` | 5-tab shell, SavedBloc root |
| `lib/core/theme/app_colors.dart` | Full color palette |
| `lib/features/auth/domain/entities/user_entity.dart` | UserEntity with `preferences: Map<String, bool>` |
| `lib/features/shared/entities/apod_entity.dart` | Shared APOD entity |

---

## If you want to add features

### To add wallpaper count tracking
1. Add `wallpaperCount: int` to `UserEntity` + `UserModel.fromSnapshot/toJson`
2. Increment in `ApodDetailPage._saveWallpaper()` via `UpdateProfileEvent`
3. Show real count in `_StatsRow` in profile_page.dart

### To add privacy page
1. Create `lib/features/profile/presentation/pages/privacy_page.dart`
2. Add route `/privacy` in `app_router.dart`
3. Wire `_AccountRow(label: 'Privacy', onTap: () => context.push('/privacy'))` in profile_page.dart

### To add real ISS pass predictions
The open-notify `iss-pass.json` endpoint is shut down. Alternatives:
- `https://hamqsl.com/solar.html` for pass data
- Celestrak TLE + satellite.js calculation (complex, requires port to Dart)

### To add search
Add a `SearchDelegate` or dedicated search route fed from `ApodRemoteDataSource` (NASA APOD supports date ranges) or `NasaImagesRemoteDataSource` (keyword search).
