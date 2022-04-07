import 'package:flutter/material.dart';
import 'package:singularity/screens/planet_detail_screen.dart';
import 'package:singularity/widgets/dash_line_painter.dart';

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
        backgroundColor: Colors.white,
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
              'assets/ivana-cajina-asuyh-_ZX54-unsplash.jpg',
              alignment: Alignment.center,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: CustomPaint(
                painter: DashLinePainter(),
                child: GridView.builder(
                  itemCount: planets.length,
                  reverse: true,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, childAspectRatio: 2.3),
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
                                      scale: 1.2,
                                      child: Image.asset(
                                        'assets/sun.png',
                                      ),
                                    ),
                                    Positioned(
                                      right: 150,
                                      bottom: 80,
                                      child: Text(
                                        planets[index],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
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
                                    right: 60,
                                    child: Text(
                                      planets[index],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlanetDetailScreen(
                                                      planetIndex: 0)));
                                    },
                                    child: Hero(
                                      tag: index,
                                      child: Transform.scale(
                                        scale: planetScale(index),
                                        child: Image.asset(
                                          'assets/$index.png',
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
      return 0.5;
    } else if (index == 2) {
      return 0.6;
    } else if (index == 3) {
      return 0.7;
    } else if (index == 4) {
      return 1;
    } else if (index == 5) {
      return 1.5;
    } else if (index == 6) {
      return 1.5;
    } else if (index == 7) {
      return 1;
    } else {
      return 0.8;
    }
  }

  double planetheight(int index) {
    if (index == 1) {
      return 0.5;
    } else if (index == 2) {
      return 0.6;
    } else if (index == 3) {
      return 0.7;
    } else if (index == 4) {
      return 1;
    } else if (index == 5) {
      return 1.5;
    } else if (index == 6) {
      return 1.5;
    } else if (index == 7) {
      return 1;
    } else {
      return 0.8;
    }
  }
}
