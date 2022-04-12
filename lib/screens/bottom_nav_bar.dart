import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/constants/colors.dart';
import 'package:singularity/screens/explore_screen.dart';
import 'package:singularity/screens/home_screen.dart';
import 'package:singularity/screens/planets_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  static const List<Widget> screens = <Widget>[
    HomeScreen(),
    PlanetsScreen(),
    ExploreScreen()
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.public_outlined,
            ),
            label: 'Planets',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore_outlined,
            ),
            label: 'Explore',
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
