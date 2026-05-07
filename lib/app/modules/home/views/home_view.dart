import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/features/cosmo_daily/presentation/bloc/cosmo_daily_bloc.dart';
import 'package:singularity/features/cosmo_daily/presentation/pages/cosmo_daily_page.dart';
import 'package:singularity/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:singularity/features/explore/presentation/pages/explore_page.dart';
import 'package:singularity/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:singularity/features/profile/presentation/pages/profile_page.dart';
import 'package:singularity/features/sky_stories/presentation/bloc/sky_stories_bloc.dart';
import 'package:singularity/features/sky_stories/presentation/pages/sky_stories_page.dart';
import 'package:singularity/features/vintage_space/presentation/bloc/vintage_space_bloc.dart';
import 'package:singularity/features/vintage_space/presentation/pages/vintage_space_page.dart';
import 'package:singularity/injection_container.dart';
import '../../../constants/colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  // Each BLoC tab is wrapped in its own BlocProvider so the BLoC's lifetime
  // is tied to the widget tree, not to a global service.
  static final List<Widget> screens = [
    BlocProvider(
      create: (_) => sl<CosmoDailyBloc>(),
      child: const CosmoDailyPage(),
    ),
    BlocProvider(
      create: (_) => sl<SkyStoriesBloc>(),
      child: const SkyStoriesPage(),
    ),
    BlocProvider(
      create: (_) => sl<VintageSpaceBloc>(),
      child: const VintageSpacePage(),
    ),
    BlocProvider(
      create: (_) => sl<ExploreBloc>()..add(LoadExploreDataEvent()),
      child: const ExplorePage(),
    ),
    BlocProvider(
      create: (_) => sl<ProfileBloc>(),
      child: const ProfilePage(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        selectedLabelStyle: TextStyle(
            color: Colors.grey.shade200,
            fontSize: 14,
            fontFamily: GoogleFonts.titilliumWeb().fontFamily),
        unselectedLabelStyle: TextStyle(
            color: Colors.grey.shade200,
            fontSize: 14,
            fontFamily: GoogleFonts.titilliumWeb().fontFamily),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            backgroundColor: Colors.black,
            label: 'Cosmo Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            backgroundColor: Colors.black,
            label: 'Sky Stories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            backgroundColor: Colors.black,
            label: 'Vintage Space',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            backgroundColor: Colors.black,
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            backgroundColor: Colors.black,
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
