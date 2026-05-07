import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/planet_entity.dart';
import 'planet_detail_page.dart';

class PlanetsPage extends StatelessWidget {
  final List<PlanetEntity> planets;

  const PlanetsPage({Key? key, required this.planets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: planets.length,
        itemBuilder: (BuildContext context, int index) {
          final planet = planets[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    PlanetDetailPage(planet: planet, heroTag: index),
              ));
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3.3,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Hero(
                          tag: index,
                          child: Transform.scale(
                            scale: _planetScale(index),
                            child: Image.asset(planet.imgUrl[0],
                                fit: BoxFit.contain),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange,
                            Colors.transparent,
                            Colors.transparent,
                            Colors.orange
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, 0, 0.6, 1],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25),
                            child: Text(planet.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26.0,
                                    fontFamily:
                                        GoogleFonts.titilliumWeb().fontFamily)),
                          ),
                          const SizedBox(height: 3.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  double _planetScale(int index) {
    switch (index) {
      case 0: return 0.9;
      case 1: return 1.0;
      case 2: return 1.1;
      case 3: return 1.35;
      case 4: return 1.5;
      case 5: return 1.5;
      case 6: return 1.6;
      default: return 1.0;
    }
  }
}
