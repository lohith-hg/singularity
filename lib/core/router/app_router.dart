import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/modules/home/views/home_view.dart';
import '../../features/auth/presentation/pages/forgot_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/cosmo_daily/presentation/pages/apod_detail_page.dart';
import '../../features/saved/presentation/bloc/saved_bloc.dart';
import '../../features/saved/presentation/pages/saved_page.dart';
import '../../features/donki/presentation/bloc/donki_bloc.dart';
import '../../features/donki/presentation/pages/donki_page.dart';
import '../../features/epic/presentation/bloc/epic_bloc.dart';
import '../../features/epic/presentation/pages/epic_page.dart';
import '../../features/exoplanets/presentation/bloc/exoplanets_bloc.dart';
import '../../features/exoplanets/presentation/pages/exoplanets_page.dart';
import '../../features/iss_tracker/presentation/bloc/iss_tracker_bloc.dart';
import '../../features/iss_tracker/presentation/pages/iss_tracker_page.dart';
import '../../features/mars_rover/presentation/bloc/mars_rover_bloc.dart';
import '../../features/mars_rover/presentation/pages/mars_rover_page.dart';
import '../../features/neo/presentation/bloc/neo_bloc.dart';
import '../../features/neo/presentation/pages/neo_page.dart';
import '../../features/profile/presentation/pages/privacy_page.dart';
import '../../features/shared/entities/apod_entity.dart';
import '../../features/vintage_space/presentation/bloc/vintage_space_bloc.dart';
import '../../features/vintage_space/presentation/pages/nasa_image_search_page.dart';
import '../../features/vintage_space/presentation/pages/vintage_space_page.dart';
import '../../injection_container.dart';

class _AuthRefreshStream extends ChangeNotifier {
  _AuthRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  refreshListenable: _AuthRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final loc = state.matchedLocation;

    if (loc == '/splash' || loc == '/onboarding') return null;
    if (!isLoggedIn && loc == '/home') return '/login';
    if (isLoggedIn && (loc == '/login' || loc == '/signup')) return '/home';

    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
    GoRoute(path: '/forgot', builder: (context, state) => const ForgotPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomeView()),
    GoRoute(
      path: '/search',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<VintageSpaceBloc>(),
        child: const NasaImageSearchPage(),
      ),
    ),
    GoRoute(path: '/privacy', builder: (context, state) => const PrivacyPage()),
    GoRoute(
      path: '/apod-detail',
      builder: (context, state) {
        final apod = state.extra as ApodEntity;
        return BlocProvider(
          create: (_) => sl<SavedBloc>(),
          child: ApodDetailPage(apod: apod),
        );
      },
    ),
    GoRoute(
      path: '/saved',
      builder: (context, state) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        return BlocProvider(
          create: (_) {
            final bloc = sl<SavedBloc>();
            if (uid != null) bloc.add(LoadSavedItemsEvent(uid));
            return bloc;
          },
          child: const SavedPage(),
        );
      },
    ),
    GoRoute(
      path: '/mars',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<MarsRoverBloc>(),
        child: const MarsRoverPage(),
      ),
    ),
    GoRoute(
      path: '/epic',
      builder: (context, state) =>
          BlocProvider(create: (_) => sl<EpicBloc>(), child: const EpicPage()),
    ),
    GoRoute(
      path: '/iss',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<IssTrackerBloc>(),
        child: const IssTrackerPage(),
      ),
    ),
    GoRoute(
      path: '/neo',
      builder: (context, state) =>
          BlocProvider(create: (_) => sl<NeoBloc>(), child: const NeoPage()),
    ),
    GoRoute(
      path: '/exoplanets',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ExoplanetsBloc>(),
        child: const ExoplanetsPage(),
      ),
    ),
    GoRoute(
      path: '/donki',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<DonkiBloc>(),
        child: const DonkiPage(),
      ),
    ),
    GoRoute(
      path: '/library',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<VintageSpaceBloc>(),
        child: const VintageSpacePage(),
      ),
    ),
  ],
);
