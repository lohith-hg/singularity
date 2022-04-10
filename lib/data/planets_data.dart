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
      lengthOfYear: '365.25 days',
      gravity: ' 9.8 m/s²',
      distanceFromSun: '1 AU',
      noOfMoons: '1',
      facts: [
        Fact(
          id: '1',
          heading: 'Plate Tectonics Keep the Planet Comfortable:'.toUpperCase(),
          discription:
              'Earth is the only planet in the Solar System with plate tectonics. Basically, the outer crust of the Earth is broken up into regions known as tectonic plates. These are floating on top of the magma interior of the Earth and can move against one another. When two plates collide, one plate will subduct (go underneath another), and where they pull apart, they will allow fresh crust to form.This process is very important, and for a number of reasons. Not only does it lead to tectonic resurfacing and geological activity (i.e. earthquakes, volcanic eruptions, mountain-building, and oceanic trench formation), it is also intrinsic to the carbon cycle. When microscopic plants in the ocean die, they fall to the bottom of the ocean.',
        ),
        Fact(
          id: '2',
          heading: 'PROTECTIVE SHIELD',
          discription:
              'Our atmosphere protects us from incoming meteoroids, most of which break up in our atmosphere before they can strike the surface.',
        ),
        Fact(
          id: '3',
          heading: 'ORBITAL SCIENCE',
          discription:
              'Many orbiting spacecraft study the Earth from above as a whole system—observing the atmosphere, ocean, glaciers, and the solid earth.',
        ),
        Fact(
          id: '4',
          heading: 'The Earth’s Molten Iron Core Creates a Magnetic Field:'
              .toUpperCase(),
          discription:
              'The Earth is like a great big magnet, with poles at the top and bottom near to the actual geographic poles. The magnetic field it creates extends thousands of kilometers out from the surface of the Earth – forming a region called the “magnetosphere“. Scientists think that this magnetic field is generated by the molten outer core of the Earth, where heat creates convection motions of conducting materials to generate electric currents.',
        ),
        Fact(
          id: '5',
          heading: 'Earth is Mostly Iron, Oxygen and Silicon:'.toUpperCase(),
          discription:
              'If you could separate the Earth out into piles of material, you’d get 32.1 % iron, 30.1% oxygen, 15.1% silicon, and 13.9% magnesium. Of course, most of this iron is actually located at the core of the Earth. If you could actually get down and sample the core, it would be 88% iron. And if you sampled the Earth’s crust, you’d find that 47% of it is oxygen.',
        )
      ]),
  Planet(
      id: '4',
      name: 'Mars',
      credits: 'nasa',
      imgUrl: ['assets/4.png'],
      discription:
          '​Mars is the fourth planet from the Sun – a dusty, cold, desert world with a very thin atmosphere. Mars is also a dynamic planet with seasons, polar ice caps, canyons, extinct volcanoes, and evidence that it was even more active in the past.Mars is one of the most explored bodies in our solar system, and it\'s the only planet where we\'ve sent rovers to roam the alien landscape.NASA currently has two rovers (Curiosity and Perseverance), one lander (InSight), and one helicopter (Ingenuity) exploring the surface of Mars.Europe,India & China also have spacecraft studying Mars from orbit.These robotic explorers have found lots of evidence that Mars was much wetter and warmer, with a thicker atmosphere, billions of years ago.',
      lengthOfYear: '1.88 Earth Years (687 Earth Days)',
      gravity: ' 3.72 m/s²',
      distanceFromSun: '1.5 AU',
      noOfMoons: '2',
      facts: [
        Fact(
          id: '1',
          heading: 'LONGER DAYS'.toUpperCase(),
          discription:
              'One day on Mars takes a little over 24 hours. Mars makes a complete orbit around the Sun (a year in Martian time) in 687 Earth days.',
        ),
        Fact(
          id: '2',
          heading: 'RUGGED TERRAIN',
          discription:
              'Mars is a rocky planet. Its solid surface has been altered by volcanoes, impacts, winds, crustal movement and chemical reactions.',
        ),
        Fact(
          id: '3',
          heading: 'RUSTY PLANET',
          discription:
              'Mars is known as the Red Planet because iron minerals in the Martian soil oxidize, or rust, causing the soil and atmosphere to look red.',
        ),
        Fact(
          id: '4',
          heading: 'TOUGH PLACE FOR LIFE'.toUpperCase(),
          discription:
              'At this time, Mars surface cannot support life as we know it. Current missions are determining Mars\' past and future potential for life.',
        ),
        Fact(
          id: '5',
          heading: 'BRING A SPACESUIT'.toUpperCase(),
          discription:
              'Mars has a thin atmosphere made up mostly of carbon dioxide (CO2), argon (Ar), nitrogen (N2), and a small amount of oxygen and water vapor.',
        )
      ]),
  Planet(
      id: '5',
      name: 'Jupiter',
      credits: 'nasa',
      imgUrl: ['assets/5.png', 'assets/5-1.png'],
      discription:
          '​Jupiter has a long history of surprising scientists – all the way back to 1610 when Galileo Galilei found the first moons beyond Earth. That discovery changed the way we see the universe.Fifth in line from the Sun, Jupiter is, by far, the largest planet in the solar system – more than twice as massive as all the other planets combined.Jupiter\'s familiar stripes and swirls are actually cold, windy clouds of ammonia and water, floating in an atmosphere of hydrogen and helium. Jupiter’s iconic Great Red Spot is a giant storm bigger than Earth that has raged for hundreds of years.One spacecraft – NASA\'s Juno orbiter – is currently exploring this giant world.',
      lengthOfYear: '11.86 Earth Years (4333 Earth Days)',
      gravity: ' 24.79 m/s²',
      distanceFromSun: '5.2 AU',
      noOfMoons: '79',
      facts: [
        Fact(
          id: '1',
          heading: 'THE GRANDEST PLANET'.toUpperCase(),
          discription:
              'Eleven Earths could fit across Jupiter’s equator. If Earth were the size of a grape, Jupiter would be the size of a basketball.',
        ),
        Fact(
          id: '2',
          heading: 'SHORT DAY/LONG YEAR',
          discription:
              'Jupiter rotates once about every 10 hours (a Jovian day), but takes about 12 Earth years to complete one orbit of the Sun (a Jovian year).',
        ),
        Fact(
          id: '3',
          heading: 'WHAT\'S INSIDE',
          discription:
              'Jupiter is a gas giant and so lacks an Earth-like surface. If it has a solid inner core at all, it’s likely only about the size of Earth.',
        ),
        Fact(
          id: '4',
          heading: 'RINGED WORLD'.toUpperCase(),
          discription:
              'In 1979 the Voyager mission discovered Jupiter’s faint ring system. All four giant planets in our solar system have ring systems.',
        ),
        Fact(
          id: '5',
          heading: 'INGREDIENTS FOR LIFE?'.toUpperCase(),
          discription:
              'Jupiter cannot support life as we know it. But some of Jupiter\'s moons have oceans beneath their crusts that might support life.',
        ),
        Fact(
          id: '6',
          heading: 'SUPER STORM'.toUpperCase(),
          discription:
              'Jupiter\'s Great Red Spot is a gigantic storm that’s about twice the size of Earth and has raged for over a century.',
        )
      ]),
  Planet(
      id: '6',
      name: 'Saturn',
      credits: 'nasa',
      imgUrl: ['assets/6.png'],
      discription:
          'Saturn is the sixth planet from the Sun and the second-largest planet in our solar system.Adorned with thousands of beautiful ringlets, Saturn is unique among the planets. It is not the only planet to have rings – made of chunks of ice and rock – but none are as spectacular or as complicated as Saturn\'s.Like fellow gas giant Jupiter, Saturn is a massive ball made mostly of hydrogen and helium.',
      lengthOfYear: '29.45 Earth Years (10,759 Earth Days)',
      gravity: ' 10.44 m/s²',
      distanceFromSun: '9.5 AU',
      noOfMoons: '62',
      facts: [
        Fact(
          id: '1',
          heading: 'A COLOSSAL PLANET'.toUpperCase(),
          discription:
              'Nine Earths side by side would almost span Saturn’s diameter. That doesn’t include Saturn’s rings.',
        ),
        Fact(
          id: '2',
          heading: 'IN DIM LIGHT',
          discription:
              'Saturn is the sixth planet from our Sun (a star) and orbits at a distance of about 886 million miles (1.4 billion kilometers) from the Sun.',
        ),
        Fact(
          id: '3',
          heading: 'SHORT DAY, LONG YEAR',
          discription:
              'Saturn takes about 10.7 hours (no one knows precisely) to rotate on its axis once—a Saturn “day”—and 29 Earth years to orbit the sun.',
        ),
        Fact(
          id: '4',
          heading: 'GAS GIANT'.toUpperCase(),
          discription:
              'Saturn is a gas-giant planet and therefore does not have a solid surface like Earth’s. But it might have a solid core somewhere in there.',
        ),
        Fact(
          id: '5',
          heading: 'HOT AIR'.toUpperCase(),
          discription:
              'Saturn\'s atmosphere is made up mostly of hydrogen (H2) and helium (He).',
        ),
        Fact(
          id: '6',
          heading: 'MINI SOLAR SYSTEM'.toUpperCase(),
          discription:
              'Saturn has 53 known moons with an additional 29 moons awaiting confirmation of their discovery—that is a total of 82 moons.',
        ),
        Fact(
          id: '7',
          heading: 'RARE DESTINATION'.toUpperCase(),
          discription:
              'Few missions have visited Saturn: Pioneer 11 and Voyagers 1 and 2 flew by; But Cassini orbited Saturn 294 times from 2004 to 2017.',
        ),
        Fact(
          id: '8',
          heading: 'LIFELESS BEHEMOTH'.toUpperCase(),
          discription:
              'Saturn cannot support life as we know it, but some of Saturn\'s moons have conditions that might support life.',
        ),
        Fact(
          id: '9',
          heading: 'ADD A DASH OF EARTH'.toUpperCase(),
          discription:
              'About two tons of Saturn’s mass came from Earth—the Cassini spacecraft was intentionally vaporized in Saturn’s atmosphere in 2017.',
        )
      ]),
  Planet(
      id: '7',
      name: 'Uranus',
      credits: 'nasa',
      imgUrl: ['assets/7.png'],
      discription:
          'Uranus is the seventh planet from the Sun, and has the third-largest diameter in our solar system. It was the first planet found with the aid of a telescope, Uranus was discovered in 1781 by astronomer William Herschel, although he originally thought it was either a comet or a star.It was two years later that the object was universally accepted as a new planet, in part because of observations by astronomer Johann Elert Bode. Herschel tried unsuccessfully to name his discovery Georgium Sidus after King George III. Instead, the scientific community accepted Bode\'s suggestion to name it Uranus, the Greek god of the sky, as suggested by Bode.​',
      lengthOfYear: '84 Earth Years (30,687 Earth Days)',
      gravity: ' 8.87 m/s²',
      distanceFromSun: '19.8 AU',
      noOfMoons: '27',
      facts: [
        Fact(
          id: '1',
          heading: 'HUGE'.toUpperCase(),
          discription:
              'Uranus is about four times wider than Earth. If Earth were a large apple, Uranus would be the size of a basketball.',
        ),
        Fact(
          id: '2',
          heading: 'SHORT-ISH DAY, LONGISH YEAR',
          discription:
              'Uranus takes about 17 hours to rotate once (a Uranian day), and about 84 Earth years to complete an orbit of the Sun (a Uranian year).',
        ),
        Fact(
          id: '3',
          heading: 'ICE GIANT',
          discription:
              'Uranus is an ice giant. Most of its mass is a hot, dense fluid of "icy" materials – water, methane and ammonia – above a small rocky core.',
        ),
        Fact(
          id: '4',
          heading: 'GASSY'.toUpperCase(),
          discription:
              'Uranus has an atmosphere made mostly of molecular hydrogen and atomic helium, with a small amount of methane.',
        ),
        Fact(
          id: '5',
          heading: 'THE OTHER RINGED WORLD'.toUpperCase(),
          discription:
              'Uranus has 13 known rings. The inner rings are narrow and dark and the outer rings are brightly colored.',
        ),
        Fact(
          id: '6',
          heading: 'A BIT LONELY'.toUpperCase(),
          discription:
              'Voyager 2 is the only spacecraft to fly by Uranus. No spacecraft has orbited this distant planet to study it at length and up close.',
        ),
        Fact(
          id: '7',
          heading: 'LIFELESS'.toUpperCase(),
          discription: 'Uranus cannot support life as we know it.',
        ),
        Fact(
          id: '8',
          heading: 'ONE COOL FACT'.toUpperCase(),
          discription:
              'Like Venus, Uranus rotates east to west. But Uranus is unique in that it rotates on its side.',
        )
      ]),
  Planet(
      id: '8',
      name: 'Neptune',
      credits: 'nasa',
      imgUrl: ['assets/8.png'],
      discription:
          'Dark, cold, and whipped by supersonic winds, ice giant Neptune is the eighth and most distant planet in our solar system.More than 30 times as far from the Sun as Earth, Neptune is the only planet in our solar system not visible to the naked eye and the first predicted by mathematics before its discovery. In 2011 Neptune completed its first 165-year orbit since its discovery in 1846.NASA\'s Voyager 2 is the only spacecraft to have visited Neptune up close. It flew past in 1989 on its way out of the solar system.',
      lengthOfYear: '164.81 Earth Years (60,190 Earth Days)',
      gravity: ' 11.15 m/s²',
      distanceFromSun: '30.1 AU',
      noOfMoons: '14',
      facts: [
        Fact(
          id: '1',
          heading: 'GIANT'.toUpperCase(),
          discription:
              'Neptune is about four times wider than Earth. If Earth were a large apple, Neptune would be the size of a basketball.',
        ),
        Fact(
          id: '2',
          heading: 'SHORT DAY, LONG YEAR',
          discription:
              'Neptune takes about 16 hours to rotate once (a Neptunian day), and about 165 Earth years to orbit the sun (a Neptunian year).',
        ),
        Fact(
          id: '3',
          heading: 'ICE GIANT',
          discription:
              'Neptune is an ice giant. Most of its mass is a hot, dense fluid of "icy" materials – water, methane and ammonia – above a small rocky core.',
        ),
        Fact(
          id: '4',
          heading: 'GASSY'.toUpperCase(),
          discription:
              'Neptune\'s atmosphere is made up mostly of molecular hydrogen, atomic helium and methane.',
        ),
        Fact(
          id: '5',
          heading: 'FAINT RINGS'.toUpperCase(),
          discription:
              'Neptune has at least five main rings and four more ring arcs, which are clumps of dust and debris likely formed by the gravity of a nearby moon.',
        ),
        Fact(
          id: '6',
          heading: 'ONE VOYAGE THERE'.toUpperCase(),
          discription:
              'Voyager 2 is the only spacecraft to have visited Neptune. No spacecraft has orbited this distant planet to study it at length and up close.',
        ),
        Fact(
          id: '7',
          heading: 'ONE COOL FACT'.toUpperCase(),
          discription:
              'Because of dwarf planet Pluto’s elliptical orbit, Pluto is sometimes closer to the Sun (and us) than Neptune is.',
        )
      ]),
];
