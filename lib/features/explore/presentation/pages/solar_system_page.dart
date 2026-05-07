import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../app/widgets/dash_line_painter.dart';
import '../../domain/entities/planet_entity.dart';
import 'planet_detail_page.dart';

class SolarSystemPage extends StatelessWidget {
  final List<PlanetEntity> planets;

  const SolarSystemPage({Key? key, required this.planets}) : super(key: key);

  static const _planetNames = [
    'Sun', 'Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          title: const Text('Solar System',
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.black,
        ),
        body: Stack(
          children: [
            Image.asset('assets/space_background.jpg',
                alignment: Alignment.center,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height),
            SingleChildScrollView(
              reverse: true,
              physics: const ClampingScrollPhysics(),
              child: CustomPaint(
                painter: DashLinePainter(),
                child: GridView.builder(
                  itemCount: _planetNames.length,
                  reverse: true,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, childAspectRatio: 2.6),
                  itemBuilder: (BuildContext context, int index) {
                    return (index == 0)
                        ? Row(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Stack(
                                children: [
                                  Transform.scale(
                                      scale: 1.25,
                                      child: Image.asset('assets/sun.png')),
                                  Positioned(
                                    right: 130,
                                    bottom: 80,
                                    child: Text(_planetNames[index],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
                                  ),
                                ],
                              ),
                            )
                          ])
                        : Row(
                            mainAxisAlignment: (index % 2 == 0)
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                            children: [
                              Stack(
                                children: [
                                  Positioned(
                                    right: _textPadding(index),
                                    top: -8,
                                    child: Text(_planetNames[index],
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
                                  ),
                                  Align(
                                    alignment: (index % 2 == 0)
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        final planetIndex = index - 1;
                                        if (planetIndex < planets.length) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => PlanetDetailPage(
                                                planet: planets[planetIndex],
                                                heroTag: planetIndex,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Hero(
                                        tag: (index - 1),
                                        child: Transform.scale(
                                          scale: _planetScale(index),
                                          child: Image.asset('assets/$index.png'),
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

  double _planetScale(int index) {
    switch (index) {
      case 1: return 0.6;
      case 2: return 0.72;
      case 3: return 0.85;
      case 4: return 1.05;
      case 5: return 1.45;
      case 6: return 1.65;
      case 7: return 1.2;
      default: return 0.78;
    }
  }

  double _textPadding(int index) {
    switch (index) {
      case 1: return 42;
      case 2: return 110;
      case 3: return 110;
      case 4: return 110;
      case 5: return 45;
      case 6: return 100;
      case 7: return 80;
      default: return 100;
    }
  }
}
