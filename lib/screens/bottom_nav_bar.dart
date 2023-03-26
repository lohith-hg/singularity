import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/constants/colors.dart';
import 'package:singularity/data/history_album.dart';
import 'package:singularity/screens/explore_screen.dart';
import 'package:singularity/screens/feed_screen.dart';
import 'package:singularity/screens/vintage_space_screen.dart';
import 'package:singularity/screens/home_screen.dart';
import 'package:singularity/screens/APOD_screen.dart';
import 'package:singularity/screens/profile_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  static List<Widget> screens = <Widget>[
    const PictureOftheDayScreen(),
    FeedsScreen(),
    VintageSpaceScreen(),
    const HomeScreen(),
    ProfileScreen(),
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
              Icons.home,
            ),
            backgroundColor: Colors.black,
            label: 'APOD',
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
