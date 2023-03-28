import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/dash_line_painter.dart';
import 'planet_detail_screen.dart';

class SolarSystemScreen extends StatefulWidget {
  const SolarSystemScreen({Key? key}) : super(key: key);

  @override
  State<SolarSystemScreen> createState() => _SolarSystemScreenState();
}

class _SolarSystemScreenState extends State<SolarSystemScreen> {
  List<String> planets = [
    'Sun',
    'Mercury',
    'Venus',
    'Earth',
    'Mars',
    'Jupiter',
    'Saturn',
    'Uranus',
    'Neptune'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          title: const Text(
            'Solar System',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.black,
        ),
        body: Stack(
          children: [
            Image.asset(
              'assets/space_background.jpg',
              alignment: Alignment.center,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            SingleChildScrollView(
              reverse: true,
              physics: const ClampingScrollPhysics(),
              child: CustomPaint(
                painter: DashLinePainter(),
                child: GridView.builder(
                  itemCount: planets.length,
                  reverse: true,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, childAspectRatio: 2.6),
                  itemBuilder: (BuildContext context, int index) {
                    return (index == 0)
                        ? Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Stack(
                                  children: [
                                    Transform.scale(
                                      scale: 1.25,
                                      child: Image.asset(
                                        'assets/sun.png',
                                      ),
                                    ),
                                    Positioned(
                                      right: 130,
                                      bottom: 80,
                                      child: Text(
                                        planets[index],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            fontFamily:
                                                GoogleFonts.titilliumWeb()
                                                    .fontFamily),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: (index % 2 == 0)
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                            children: [
                              Stack(
                                children: [
                                  Positioned(
                                    right: planetTextPadding(index),
                                    top: -8,
                                    child: Text(
                                      planets[index],
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontFamily: GoogleFonts.titilliumWeb()
                                              .fontFamily),
                                    ),
                                  ),
                                  Align(
                                    alignment: (index % 2 == 0)
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PlanetDetailScreen(
                                                    planetIndex: (index - 1)),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: (index - 1),
                                        child: Transform.scale(
                                          scale: planetScale(index),
                                          child: Image.asset(
                                            'assets/$index.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double planetScale(int index) {
    if (index == 1) {
      return 0.6;
    } else if (index == 2) {
      return 0.72;
    } else if (index == 3) {
      return 0.85;
    } else if (index == 4) {
      return 1.05;
    } else if (index == 5) {
      return 1.45;
    } else if (index == 6) {
      return 1.65;
    } else if (index == 7) {
      return 1.2;
    } else {
      return 0.78;
    }
  }

  double planetTextPadding(int index) {
    if (index == 1) {
      return 42;
    } else if (index == 2) {
      return 110;
    } else if (index == 3) {
      return 110;
    } else if (index == 4) {
      return 110;
    } else if (index == 5) {
      return 45;
    } else if (index == 6) {
      return 100;
    } else if (index == 7) {
      return 80;
    } else {
      return 100;
    }
  }

  // EdgeInsetsGeometry planetpadding(int index) {
  //   if (index == 1) {
  //     return const EdgeInsets.only(left: 15);
  //   } else if (index == 2) {
  //     return const EdgeInsets.only(right: 10);
  //   } else if (index == 3) {
  //     return const EdgeInsets.only(left: 10);
  //   } else if (index == 4) {
  //     return const EdgeInsets.only(right: 10);
  //   } else if (index == 5) {
  //     return const EdgeInsets.only(left: 10);
  //   } else if (index == 6) {
  //     return const EdgeInsets.only(right: 10);
  //   } else if (index == 7) {
  //     return const EdgeInsets.only(left: 10);
  //   } else {
  //     return const EdgeInsets.only(right: 10);
  //   }
  // }
}
