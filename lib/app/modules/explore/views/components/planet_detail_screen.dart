import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/colors.dart';
import '../../../../data/planets_data.dart';
import '../../../../model/planet.dart';

// ignore: must_be_immutable
class PlanetDetailScreen extends StatefulWidget {
  int planetIndex;
  PlanetDetailScreen({Key? key, required this.planetIndex}) : super(key: key);

  @override
  State<PlanetDetailScreen> createState() => _PlanetDetailScreenState();
}

class _PlanetDetailScreenState extends State<PlanetDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 40),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Planet _planet = planets[widget.planetIndex];
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _planet.name,
          style: TextStyle(fontFamily: GoogleFonts.titilliumWeb().fontFamily),
        ),
      ),
      body: ListView(physics: const BouncingScrollPhysics(), children: [
        Column(
          children: [
            Hero(
              tag: widget.planetIndex,
              child: Transform.scale(
                scale: planetScale(widget.planetIndex),
                child: Image.asset(
                  _planet.imgUrl[0],
                  height: 300,
                ),
              ),
            ),
            // RotationTransition(
            //   alignment: Alignment.center,
            //   turns: _animationController,
            //   child: Hero(
            //     tag: widget.planetIndex,
            //     child: Transform.scale(
            //       scale: planetScale(widget.planetIndex),
            //       child: Image.asset(
            //         _planet.imgUrl[0],
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Image Credits : ${_planet.credits}',
                style: TextStyle(
                    color: Colors.grey.shade200,
                    fontSize: 14,
                    fontFamily: GoogleFonts.titilliumWeb().fontFamily),
              ),
            )
          ],
        ),
        //ImageCard(imgUrl: _planet.imgUrl[0], credits: _planet.credits),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(_planet.name,
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Length of year : ${_planet.lengthOfYear}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Number of moons : ${_planet.noOfMoons}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Distance from sun : ${_planet.distanceFromSun}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Gravity : ${_planet.gravity}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('About',
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              ),
              Text(_planet.discription,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('Things You Should Know About ${_planet.name}',
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _planet.facts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${_planet.facts[index].id}.) ${_planet.facts[index].heading}',
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 23,
                              fontFamily:
                                  GoogleFonts.titilliumWeb().fontFamily)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(_planet.facts[index].discription,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily:
                                    GoogleFonts.titilliumWeb().fontFamily)),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        )
      ]),
    );
  }

  double planetScale(int index) {
    if (index == 0) {
      return 0.9;
    } else if (index == 1) {
      return 1.35;
    } else if (index == 2) {
      return 1.45;
    } else if (index == 3) {
      return 1.8;
    } else if (index == 4) {
      return 1.9;
    } else if (index == 5) {
      return 1.7;
    } else if (index == 6) {
      return 1.8;
    } else {
      return 1.45;
    }
  }
}
