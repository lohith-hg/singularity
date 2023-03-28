import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../widgets/custom_container.dart';
import '../controllers/explore_controller.dart';
import 'components/explore_screen.dart';
import 'components/planets_screen.dart';
import 'components/solar_system_screen.dart';

class ExploreView extends GetView<ExploreController>  {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          'Explore',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.black,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SolarSystemScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomContainer(
                imgUrl: 'assets/solarSystem.jpg',
                title: 'Explore Solar System',
                heightFactor: 1.3,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PlanetsScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: CustomContainer(
                imgUrl: 'assets/3.png',
                title: 'Planets',
                heightFactor: 3.4,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ExploreScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomContainer(
                imgUrl: 'assets/polar-lights-5858656_1920.jpg',
                title: 'Theories',
                heightFactor: 2.8,
              ),
            ),
          )
        ],
      ),
    );
  }
}