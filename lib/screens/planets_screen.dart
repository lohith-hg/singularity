import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:singularity/constants/colors.dart';
import 'package:singularity/data/planets_data.dart';
import 'package:singularity/screens/planet_detail_screen.dart';

class PlanetsScreen extends StatefulWidget {
  const PlanetsScreen({Key? key}) : super(key: key);

  @override
  State<PlanetsScreen> createState() => _PlanetsScreenState();
}

class _PlanetsScreenState extends State<PlanetsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: planets.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        PlanetDetailScreen(planetIndex: index),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                width: double.infinity,
                //height: MediaQuery.of(context).size.height / 2.5,
                height: MediaQuery.of(context).size.height / 3.3,

                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Hero(
                            tag: (index),
                            child: Transform.scale(
                              scale: planetScale(index),
                              child: Image.asset(
                                planets[index].imgUrl[0],
                                fit: BoxFit.contain,
                              ),
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
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Text(planets[index].name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26.0,
                                      fontFamily: GoogleFonts.titilliumWeb()
                                          .fontFamily)),
                            ),
                            const SizedBox(
                              height: 3.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  double planetScale(int index) {
    if (index == 0) {
      return 0.9;
    } else if (index == 1) {
      return 1;
    } else if (index == 2) {
      return 1.1;
    } else if (index == 3) {
      return 1.35;
    } else if (index == 4) {
      return 1.5;
    } else if (index == 5) {
      return 1.5;
    } else if (index == 6) {
      return 1.6;
    } else {
      return 1;
    }
  }
}
