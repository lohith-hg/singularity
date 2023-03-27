import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/app/modules/cosmo_daily/views/cosmo_daily_view.dart';
import 'package:singularity/app/modules/explore/views/explore_view.dart';
import 'package:singularity/app/modules/profile/views/profile_view.dart';
import 'package:singularity/app/modules/sky_stories/views/sky_stories_view.dart';
import 'package:singularity/app/modules/vintage_space/views/vintage_space_view.dart';
import '../../../constants/colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  static List<Widget> screens = <Widget>[
    const CosmoDailyView(),
    SkyStoriesView(),
    VintageSpaceView(),
    const ExploreView(),
    ProfileView(),
    //const ExploreScreen(),
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
            icon: Icon(
              Icons.public,
            ),
            backgroundColor: Colors.black,
            label: 'Cosmo Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            backgroundColor: Colors.black,
            label: 'Sky Stories',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera,
            ),
            backgroundColor: Colors.black,
            label: 'Vintage Space',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore_outlined,
            ),
            backgroundColor: Colors.black,
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
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
