import 'package:singularity/data/planet.dart';

List<Planet> planets = [
  Planet(
      id: '1',
      name: 'Mercury',
      credits: 'nasa',
      imgUrl: ['assets/1.png'],
      discription:
          'Mercury, our solar system\'s smallest planet and the one closest to the Sun, is just slightly larger than Earth\'s Moon.The Sun would appear more than three times as huge from the surface of Mercury as it does from Earth, and illumination would be up to seven times brighter. Mercury, despite its close proximity to the Sun, is not the hottest planet in our solar system; that honour goes to Venus, which has a dense atmosphere.The Sun appears to rise briefly, set, and rise again from some portions of Mercury\'s surface due to its elliptical – egg-shaped – orbit and sluggish spin. At sunset, the same thing happens in reverse.',
      lengthOfYear: '88 Earth Days',
      gravity: ' 3.7 m/s²',
      distanceFromSun: '0.4 AU (astronomical unit)',
      noOfMoons: '0',
      facts: [
        Fact(
          id: '1',
          heading: 'FASTEST PLANET',
          discription:
              'Mercury is the fastest planet in our solar system, moving at about 29 miles per second (47 kilometres per second) across space. A planet\'s speed increases as it gets closer to the Sun. Mercury has the shortest year of all the planets in our solar system - 88 days – since it is the quickest planet and travels the smallest distance around the Sun.',
        ),
        Fact(
          id: '2',
          heading: 'ROUGH SURFACE',
          discription:
              'Mercury is a rocky planet, also known as a terrestrial planet. Mercury has a solid, cratered surface, much like the Earth\'s moon.',
        ),
        Fact(
          id: '3',
          heading: 'CAN\'T BREATHE THERE',
          discription:
              'Mercury\'s thin atmosphere, or exosphere, is composed mostly of oxygen (O2), sodium (Na), hydrogen (H2), helium (He), and potassium (K). ',
        ),
        Fact(
          id: '4',
          heading: 'TOUGH PLACE FOR LIFE',
          discription:
              'It is unlikely that life as we know it could survive on Mercury due to solar radiation, and extreme temperatures.',
        ),
        Fact(
          id: '5',
          heading: 'ROBOTIC VISITORS',
          discription:
              'Two NASA missions have explored Mercury: Mariner 10 was the first to fly by Mercury, and MESSENGER was the first to orbit. ESA\'s BepiColombo is on its way to Mercury.',
        )
      ]),
  Planet(
      id: '2',
      name: 'Venus',
      credits: 'nasa',
      imgUrl: ['assets/2.png'],
      discription:
          'Venus is Earth\'s nearest planetary neighbour and is the second planet from the Sun. It\'s one of the four inner terrestrial (or rocky) planets, and because of its size and density, it\'s often referred to as Earth\'s twin. However, these aren\'t identical twins; there are significant distinctions between the two worlds.Venus has a dense, toxic atmosphere packed with carbon dioxide, as well as thick, yellowish clouds of sulfuric acid that trap heat and cause a runaway greenhouse effect. Despite its proximity to the Sun, Mercury is the hottest planet in our solar system. On Venus, the surface temperature is around 900 degrees Fahrenheit (475 degrees Celsius), which is hot enough to melt lead. The surface is a rusty colour, with thousands of large volcanoes and intensely crunched mountains. Scientists believe that some volcanoes may still be active.At its surface, Venus possesses crushing air pressure - more than 90 times that of Earth – similar to the pressure found a mile beneath the ocean on Earth. Another significant distinction from Earth is that Venus, unlike the majority of the other planets in the solar system, revolves on its axis backward. This means that the Sun rises in the west and sets in the east on Venus, which is the polar opposite of what we see on Earth. (It\'s not the only planet in our solar system that rotates in an unusual way; Uranus rotates on its side.)',
      lengthOfYear: '225 Earth Days',
      gravity: ' 8.87 m/s²',
      distanceFromSun: '0.7 AU (astronomical unit)',
      noOfMoons: '0',
      facts: [
        Fact(
          id: '1',
          heading: 'LONG DAYS, SHORT YEARS',
          discription:
              'Venus rotates very slowly on its axis – one day on Venus lasts 243 Earth days. The planet orbits the Sun faster than Earth, however, so one year on Venus takes only about 225 Earth days, making a Venusian day longer than its year!',
        ),
        Fact(
          id: '2',
          heading: 'STINKY CLOUDS',
          discription:
              'Venus is permanently shrouded in thick, toxic clouds of sulfuric acid that start at an altitude of 28 to 43 miles (45 to 70 kilometers). The clouds smell like rotten eggs!',
        ),
        Fact(
          id: '3',
          heading: 'TOXIC TWIN',
          discription:
              'Venus is often called "Earth’s twin" because they’re similar in size and structure, but Venus has extreme surface heat and a dense, toxic atmosphere. If the Sun were as tall as a typical front door, Earth and Venus would each be about the size of a nickel.',
        ),
        Fact(
          id: '4',
          heading: 'BACKWARD SUNRISE',
          discription:
              'Venus rotates backward on its axis compared to most planets in our solar system. This means the Sun rises in the west and sets in the east, opposite of what we see on Earth.',
        ),
        Fact(
          id: '5',
          heading: 'LIFE ON VENUS',
          discription:
              'Venus is an unlikely place for life as we know it, but some scientists theorize microbes might exist high in the clouds where it’s cooler and the pressure is similar to Earth’s surface. Phosphine, a possible indicator of microbial life, has been observed in the clouds.',
        )
      ]),
  Planet(
      id: '3',
      name: 'Earth',
      credits: 'nasa',
      imgUrl: ['assets/3.png'],
      discription:
          'Earth is the third planet from the Sun and the only astronomical object known to harbor life. While large amounts of water can be found throughout the Solar System, only Earth sustains liquid surface water. About 71% of Earth\'s surface is made up of the ocean, dwarfing Earth\'s polar ice, lakes, and rivers. The remaining 29% of Earth\'s surface is land, consisting of continents and islands.',
      lengthOfYear: '365 days',
      gravity: ' 9.8 m/s²',
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
