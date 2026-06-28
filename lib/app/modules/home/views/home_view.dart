import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/widgets/s_nav_bar.dart';
import '../../../../features/cosmo_daily/presentation/bloc/cosmo_daily_bloc.dart';
import '../../../../features/cosmo_daily/presentation/pages/cosmo_daily_page.dart';
import '../../../../features/mars_rover/presentation/bloc/mars_rover_bloc.dart';
import '../../../../features/mars_rover/presentation/pages/mars_rover_page.dart';
import '../../../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../../../features/profile/presentation/pages/profile_page.dart';
import '../../../../features/saved/presentation/bloc/saved_bloc.dart';
import '../../../../features/vintage_space/presentation/bloc/vintage_space_bloc.dart';
import '../../../../features/vintage_space/presentation/pages/vintage_space_page.dart';
import '../../../../injection_container.dart';

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
      // 0 — Today
      BlocProvider(
        create: (_) => sl<CosmoDailyBloc>(),
        child: const CosmoDailyPage(),
      ),
      // 1 — Mars
      BlocProvider(
        create: (_) => sl<MarsRoverBloc>()..add(LoadAllRoversEvent()),
        child: const MarsRoverPage(),
      ),
      // 2 — Vault
      BlocProvider(
        create: (_) => sl<VintageSpaceBloc>()..add(LoadVintageSpaceEvent()),
        child: const VintageSpacePage(embedded: true),
      ),
      // 3 — Me
      BlocProvider(
        create: (_) => sl<ProfileBloc>(),
        child: const ProfilePage(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SavedBloc>()..add(const LoadSavedItemsEvent()),
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
