import 'package:flutter/material.dart';
import 'package:singularity/constants/colors.dart';
import 'package:singularity/data/data.dart';
import 'package:singularity/data/planet.dart';
import 'package:singularity/widgets/image_card.dart';

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
        title: Text(_planet.name),
      ),
      body: ListView(children: [
        Column(
          children: [
            RotationTransition(
                alignment: Alignment.center,
                turns: _animationController,
                child: Hero(tag: (3), child: Image.asset(_planet.imgUrl[0]))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Image Credits : ${_planet.credits}',
                style: TextStyle(color: Colors.grey.shade200, fontSize: 14),
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
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Length of year : ${_planet.lengthOfYear}',
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Number of moons : ${_planet.noOfMoons}',
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Distance from sun : ${_planet.distanceFromSun}',
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Gravity : ${_planet.gravity}',
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('About',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              Text(_planet.discription,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        )
      ]),
    );
  }
}
