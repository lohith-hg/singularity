import 'package:singularity/data/planet.dart';

List<Planet> planets = [
  Planet(
      id: '3',
      name: 'Earth',
      credits: 'nasa',
      imgUrl: ['assets/3.png'],
      discription:
          'Earth is the third planet from the Sun and the only astronomical object known to harbor life. While large amounts of water can be found throughout the Solar System, only Earth sustains liquid surface water. About 71% of Earth\'s surface is made up of the ocean, dwarfing Earth\'s polar ice, lakes, and rivers. The remaining 29% of Earth\'s surface is land, consisting of continents and islands.',
      lengthOfYear: '365 days',
      gravity: ' 9.807 m/s^2',
      distanceFromSun: '1 AU',
      noOfMoons: '1',
      facts: [
        Fact(
            id: '1',
            heading: 'MEASURING UP',
            discription:
                'If the Sun were as tall as a typical front door, Earth would be the size of a nickel.')
      ])
];
