import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/widgets/s_nav_bar.dart';
import '../../../../features/cosmo_daily/presentation/bloc/cosmo_daily_bloc.dart';
import '../../../../features/cosmo_daily/presentation/pages/cosmo_daily_page.dart';
import '../../../../features/explore/presentation/bloc/explore_bloc.dart';
import '../../../../features/explore/presentation/pages/explore_page.dart';
import '../../../../features/mars_rover/presentation/bloc/mars_rover_bloc.dart';
import '../../../../features/mars_rover/presentation/pages/mars_rover_page.dart';
import '../../../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../../../features/profile/presentation/pages/profile_page.dart';
import '../../../../features/saved/presentation/bloc/saved_bloc.dart';
import '../../../../injection_container.dart';
import 'tracker_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      BlocProvider(
        create: (_) => sl<CosmoDailyBloc>(),
        child: const CosmoDailyPage(),
      ),
      BlocProvider(
        create: (_) => sl<ExploreBloc>()..add(LoadExploreDataEvent()),
        child: const ExplorePage(),
      ),
      const TrackerPage(),
      BlocProvider(
        create: (_) => sl<MarsRoverBloc>()..add(LoadAllRoversEvent()),
        child: const MarsRoverPage(),
      ),
      BlocProvider(
        create: (_) => sl<ProfileBloc>(),
        child: const ProfilePage(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = sl<SavedBloc>();
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) bloc.add(LoadSavedItemsEvent(uid));
        return bloc;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        extendBody: true,
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: SNavBar(
          selectedIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
        ),
      ),
    );
  }
}
