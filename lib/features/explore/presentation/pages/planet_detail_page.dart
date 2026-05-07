import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/planet_entity.dart';

class PlanetDetailPage extends StatefulWidget {
  final PlanetEntity planet;
  final int heroTag;

  const PlanetDetailPage({
    Key? key,
    required this.planet,
    required this.heroTag,
  }) : super(key: key);

  @override
  State<PlanetDetailPage> createState() => _PlanetDetailPageState();
}

class _PlanetDetailPageState extends State<PlanetDetailPage>
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
    final planet = widget.planet;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          planet.name,
          style: TextStyle(fontFamily: GoogleFonts.titilliumWeb().fontFamily),
        ),
      ),
      body: ListView(physics: const BouncingScrollPhysics(), children: [
        Column(
          children: [
            Hero(
              tag: widget.heroTag,
              child: Transform.scale(
                scale: _planetScale(widget.heroTag),
                child: Image.asset(planet.imgUrl[0], height: 300),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Image Credits : ${planet.credits}',
                style: TextStyle(
                    color: Colors.grey.shade200,
                    fontSize: 14,
                    fontFamily: GoogleFonts.titilliumWeb().fontFamily),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(planet.name,
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Length of year : ${planet.lengthOfYear}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Number of moons : ${planet.noOfMoons}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Distance from sun : ${planet.distanceFromSun}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Gravity : ${planet.gravity}',
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
              Text(planet.description,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('Things You Should Know About ${planet.name}',
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
                itemCount: planet.facts.length,
                itemBuilder: (BuildContext context, int index) {
                  final fact = planet.facts[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${fact.id}.) ${fact.heading}',
                          style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 23,
                              fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(fact.description,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: GoogleFonts.titilliumWeb().fontFamily)),
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

  double _planetScale(int index) {
    switch (index) {
      case 0: return 0.9;
      case 1: return 1.35;
      case 2: return 1.45;
      case 3: return 1.8;
      case 4: return 1.9;
      case 5: return 1.7;
      case 6: return 1.8;
      default: return 1.45;
    }
  }
}
