import '../models/article_model.dart';
import '../models/planet_model.dart';

abstract class ExploreLocalDataSource {
  Future<List<PlanetModel>> getPlanets();
  Future<List<ArticleModel>> getArticles();
}

class ExploreLocalDataSourceImpl implements ExploreLocalDataSource {
  @override
  Future<List<PlanetModel>> getPlanets() async => _planets;

  @override
  Future<List<ArticleModel>> getArticles() async => _articles;
}

// ---------------------------------------------------------------------------
// Static data (moved from app/data/planets_data.dart)
// ---------------------------------------------------------------------------

final List<PlanetModel> _planets = [
  const PlanetModel(
    id: '1',
    name: 'Mercury',
    credits: 'nasa',
    imgUrl: ['assets/1.png'],
    description:
        'Mercury, our solar system\'s smallest planet and the one closest to the Sun, is just slightly larger than Earth\'s Moon.The Sun would appear more than three times as huge from the surface of Mercury as it does from Earth, and illumination would be up to seven times brighter. Mercury, despite its close proximity to the Sun, is not the hottest planet in our solar system; that honour goes to Venus, which has a dense atmosphere.The Sun appears to rise briefly, set, and rise again from some portions of Mercury\'s surface due to its elliptical – egg-shaped – orbit and sluggish spin. At sunset, the same thing happens in reverse.',
    lengthOfYear: '88 Earth Days',
    gravity: ' 3.7 m/s²',
    distanceFromSun: '0.4 AU (astronomical unit)',
    noOfMoons: '0',
    facts: [
      FactModel(
        id: '1',
        heading: 'FASTEST PLANET',
        description:
            'Mercury is the fastest planet in our solar system, moving at about 29 miles per second (47 kilometres per second) across space. A planet\'s speed increases as it gets closer to the Sun. Mercury has the shortest year of all the planets in our solar system - 88 days – since it is the quickest planet and travels the smallest distance around the Sun.',
      ),
      FactModel(
        id: '2',
        heading: 'ROUGH SURFACE',
        description:
            'Mercury is a rocky planet, also known as a terrestrial planet. Mercury has a solid, cratered surface, much like the Earth\'s moon.',
      ),
      FactModel(
        id: '3',
        heading: 'CAN\'T BREATHE THERE',
        description:
            'Mercury\'s thin atmosphere, or exosphere, is composed mostly of oxygen (O2), sodium (Na), hydrogen (H2), helium (He), and potassium (K). ',
      ),
      FactModel(
        id: '4',
        heading: 'TOUGH PLACE FOR LIFE',
        description:
            'It is unlikely that life as we know it could survive on Mercury due to solar radiation, and extreme temperatures.',
      ),
      FactModel(
        id: '5',
        heading: 'ROBOTIC VISITORS',
        description:
            'Two NASA missions have explored Mercury: Mariner 10 was the first to fly by Mercury, and MESSENGER was the first to orbit. ESA\'s BepiColombo is on its way to Mercury.',
      ),
    ],
  ),
  const PlanetModel(
    id: '2',
    name: 'Venus',
    credits: 'nasa',
    imgUrl: ['assets/2.png'],
    description:
        'Venus is Earth\'s nearest planetary neighbour and is the second planet from the Sun. It\'s one of the four inner terrestrial (or rocky) planets, and because of its size and density, it\'s often referred to as Earth\'s twin. However, these aren\'t identical twins; there are significant distinctions between the two worlds.Venus has a dense, toxic atmosphere packed with carbon dioxide, as well as thick, yellowish clouds of sulfuric acid that trap heat and cause a runaway greenhouse effect. Despite its proximity to the Sun, Mercury is the hottest planet in our solar system. On Venus, the surface temperature is around 900 degrees Fahrenheit (475 degrees Celsius), which is hot enough to melt lead. The surface is a rusty colour, with thousands of large volcanoes and intensely crunched mountains. Scientists believe that some volcanoes may still be active.At its surface, Venus possesses crushing air pressure - more than 90 times that of Earth – similar to the pressure found a mile beneath the ocean on Earth. Another significant distinction from Earth is that Venus, unlike the majority of the other planets in the solar system, revolves on its axis backward. This means that the Sun rises in the west and sets in the east on Venus, which is the polar opposite of what we see on Earth. (It\'s not the only planet in our solar system that rotates in an unusual way; Uranus rotates on its side.)',
    lengthOfYear: '225 Earth Days',
    gravity: ' 8.87 m/s²',
    distanceFromSun: '0.7 AU (astronomical unit)',
    noOfMoons: '0',
    facts: [
      FactModel(
        id: '1',
        heading: 'LONG DAYS, SHORT YEARS',
        description:
            'Venus rotates very slowly on its axis – one day on Venus lasts 243 Earth days. The planet orbits the Sun faster than Earth, however, so one year on Venus takes only about 225 Earth days, making a Venusian day longer than its year!',
      ),
      FactModel(
        id: '2',
        heading: 'STINKY CLOUDS',
        description:
            'Venus is permanently shrouded in thick, toxic clouds of sulfuric acid that start at an altitude of 28 to 43 miles (45 to 70 kilometers). The clouds smell like rotten eggs!',
      ),
      FactModel(
        id: '3',
        heading: 'TOXIC TWIN',
        description:
            'Venus is often called "Earth\'s twin" because they\'re similar in size and structure, but Venus has extreme surface heat and a dense, toxic atmosphere. If the Sun were as tall as a typical front door, Earth and Venus would each be about the size of a nickel.',
      ),
      FactModel(
        id: '4',
        heading: 'BACKWARD SUNRISE',
        description:
            'Venus rotates backward on its axis compared to most planets in our solar system. This means the Sun rises in the west and sets in the east, opposite of what we see on Earth.',
      ),
      FactModel(
        id: '5',
        heading: 'LIFE ON VENUS',
        description:
            'Venus is an unlikely place for life as we know it, but some scientists theorize microbes might exist high in the clouds where it\'s cooler and the pressure is similar to Earth\'s surface. Phosphine, a possible indicator of microbial life, has been observed in the clouds.',
      ),
    ],
  ),
  const PlanetModel(
    id: '3',
    name: 'Earth',
    credits: 'nasa',
    imgUrl: ['assets/3.png'],
    description:
        'Earth is the third planet from the Sun and the only astronomical object known to harbor life. While large amounts of water can be found throughout the Solar System, only Earth sustains liquid surface water. About 71% of Earth\'s surface is made up of the ocean, dwarfing Earth\'s polar ice, lakes, and rivers. The remaining 29% of Earth\'s surface is land, consisting of continents and islands.',
    lengthOfYear: '365.25 days',
    gravity: ' 9.8 m/s²',
    distanceFromSun: '1 AU',
    noOfMoons: '1',
    facts: [
      FactModel(
        id: '1',
        heading: 'PLATE TECTONICS KEEP THE PLANET COMFORTABLE:',
        description:
            'Earth is the only planet in the Solar System with plate tectonics. Basically, the outer crust of the Earth is broken up into regions known as tectonic plates. These are floating on top of the magma interior of the Earth and can move against one another. When two plates collide, one plate will subduct (go underneath another), and where they pull apart, they will allow fresh crust to form.This process is very important, and for a number of reasons. Not only does it lead to tectonic resurfacing and geological activity (i.e. earthquakes, volcanic eruptions, mountain-building, and oceanic trench formation), it is also intrinsic to the carbon cycle. When microscopic plants in the ocean die, they fall to the bottom of the ocean.',
      ),
      FactModel(
        id: '2',
        heading: 'PROTECTIVE SHIELD',
        description:
            'Our atmosphere protects us from incoming meteoroids, most of which break up in our atmosphere before they can strike the surface.',
      ),
      FactModel(
        id: '3',
        heading: 'ORBITAL SCIENCE',
        description:
            'Many orbiting spacecraft study the Earth from above as a whole system—observing the atmosphere, ocean, glaciers, and the solid earth.',
      ),
      FactModel(
        id: '4',
        heading: 'THE EARTH\'S MOLTEN IRON CORE CREATES A MAGNETIC FIELD:',
        description:
            'The Earth is like a great big magnet, with poles at the top and bottom near to the actual geographic poles. The magnetic field it creates extends thousands of kilometers out from the surface of the Earth – forming a region called the "magnetosphere". Scientists think that this magnetic field is generated by the molten outer core of the Earth, where heat creates convection motions of conducting materials to generate electric currents.',
      ),
      FactModel(
        id: '5',
        heading: 'EARTH IS MOSTLY IRON, OXYGEN AND SILICON:',
        description:
            'If you could separate the Earth out into piles of material, you\'d get 32.1 % iron, 30.1% oxygen, 15.1% silicon, and 13.9% magnesium. Of course, most of this iron is actually located at the core of the Earth. If you could actually get down and sample the core, it would be 88% iron. And if you sampled the Earth\'s crust, you\'d find that 47% of it is oxygen.',
      ),
    ],
  ),
  const PlanetModel(
    id: '4',
    name: 'Mars',
    credits: 'nasa',
    imgUrl: ['assets/4.png'],
    description:
        '​Mars is the fourth planet from the Sun – a dusty, cold, desert world with a very thin atmosphere. Mars is also a dynamic planet with seasons, polar ice caps, canyons, extinct volcanoes, and evidence that it was even more active in the past.Mars is one of the most explored bodies in our solar system, and it\'s the only planet where we\'ve sent rovers to roam the alien landscape.NASA currently has two rovers (Curiosity and Perseverance), one lander (InSight), and one helicopter (Ingenuity) exploring the surface of Mars.Europe,India & China also have spacecraft studying Mars from orbit.These robotic explorers have found lots of evidence that Mars was much wetter and warmer, with a thicker atmosphere, billions of years ago.',
    lengthOfYear: '1.88 Earth Years (687 Earth Days)',
    gravity: ' 3.72 m/s²',
    distanceFromSun: '1.5 AU',
    noOfMoons: '2',
    facts: [
      FactModel(
        id: '1',
        heading: 'LONGER DAYS',
        description:
            'One day on Mars takes a little over 24 hours. Mars makes a complete orbit around the Sun (a year in Martian time) in 687 Earth days.',
      ),
      FactModel(
        id: '2',
        heading: 'RUGGED TERRAIN',
        description:
            'Mars is a rocky planet. Its solid surface has been altered by volcanoes, impacts, winds, crustal movement and chemical reactions.',
      ),
      FactModel(
        id: '3',
        heading: 'RUSTY PLANET',
        description:
            'Mars is known as the Red Planet because iron minerals in the Martian soil oxidize, or rust, causing the soil and atmosphere to look red.',
      ),
      FactModel(
        id: '4',
        heading: 'TOUGH PLACE FOR LIFE',
        description:
            'At this time, Mars surface cannot support life as we know it. Current missions are determining Mars\' past and future potential for life.',
      ),
      FactModel(
        id: '5',
        heading: 'BRING A SPACESUIT',
        description:
            'Mars has a thin atmosphere made up mostly of carbon dioxide (CO2), argon (Ar), nitrogen (N2), and a small amount of oxygen and water vapor.',
      ),
    ],
  ),
  const PlanetModel(
    id: '5',
    name: 'Jupiter',
    credits: 'nasa',
    imgUrl: ['assets/5.png'],
    description:
        '​Jupiter has a long history of surprising scientists – all the way back to 1610 when Galileo Galilei found the first moons beyond Earth. That discovery changed the way we see the universe.Fifth in line from the Sun, Jupiter is, by far, the largest planet in the solar system – more than twice as massive as all the other planets combined.Jupiter\'s familiar stripes and swirls are actually cold, windy clouds of ammonia and water, floating in an atmosphere of hydrogen and helium. Jupiter\'s iconic Great Red Spot is a giant storm bigger than Earth that has raged for hundreds of years.One spacecraft – NASA\'s Juno orbiter – is currently exploring this giant world.',
    lengthOfYear: '11.86 Earth Years (4333 Earth Days)',
    gravity: ' 24.79 m/s²',
    distanceFromSun: '5.2 AU',
    noOfMoons: '79',
    facts: [
      FactModel(
        id: '1',
        heading: 'THE GRANDEST PLANET',
        description:
            'Eleven Earths could fit across Jupiter\'s equator. If Earth were the size of a grape, Jupiter would be the size of a basketball.',
      ),
      FactModel(
        id: '2',
        heading: 'SHORT DAY/LONG YEAR',
        description:
            'Jupiter rotates once about every 10 hours (a Jovian day), but takes about 12 Earth years to complete one orbit of the Sun (a Jovian year).',
      ),
      FactModel(
        id: '3',
        heading: 'WHAT\'S INSIDE',
        description:
            'Jupiter is a gas giant and so lacks an Earth-like surface. If it has a solid inner core at all, it\'s likely only about the size of Earth.',
      ),
      FactModel(
        id: '4',
        heading: 'RINGED WORLD',
        description:
            'In 1979 the Voyager mission discovered Jupiter\'s faint ring system. All four giant planets in our solar system have ring systems.',
      ),
      FactModel(
        id: '5',
        heading: 'INGREDIENTS FOR LIFE?',
        description:
            'Jupiter cannot support life as we know it. But some of Jupiter\'s moons have oceans beneath their crusts that might support life.',
      ),
      FactModel(
        id: '6',
        heading: 'SUPER STORM',
        description:
            'Jupiter\'s Great Red Spot is a gigantic storm that\'s about twice the size of Earth and has raged for over a century.',
      ),
    ],
  ),
  const PlanetModel(
    id: '6',
    name: 'Saturn',
    credits: 'nasa',
    imgUrl: ['assets/6.png'],
    description:
        'Saturn is the sixth planet from the Sun and the second-largest planet in our solar system.Adorned with thousands of beautiful ringlets, Saturn is unique among the planets. It is not the only planet to have rings – made of chunks of ice and rock – but none are as spectacular or as complicated as Saturn\'s.Like fellow gas giant Jupiter, Saturn is a massive ball made mostly of hydrogen and helium.',
    lengthOfYear: '29.45 Earth Years (10,759 Earth Days)',
    gravity: ' 10.44 m/s²',
    distanceFromSun: '9.5 AU',
    noOfMoons: '62',
    facts: [
      FactModel(
        id: '1',
        heading: 'A COLOSSAL PLANET',
        description:
            'Nine Earths side by side would almost span Saturn\'s diameter. That doesn\'t include Saturn\'s rings.',
      ),
      FactModel(
        id: '2',
        heading: 'IN DIM LIGHT',
        description:
            'Saturn is the sixth planet from our Sun (a star) and orbits at a distance of about 886 million miles (1.4 billion kilometers) from the Sun.',
      ),
      FactModel(
        id: '3',
        heading: 'SHORT DAY, LONG YEAR',
        description:
            'Saturn takes about 10.7 hours (no one knows precisely) to rotate on its axis once—a Saturn "day"—and 29 Earth years to orbit the sun.',
      ),
      FactModel(
        id: '4',
        heading: 'GAS GIANT',
        description:
            'Saturn is a gas-giant planet and therefore does not have a solid surface like Earth\'s. But it might have a solid core somewhere in there.',
      ),
      FactModel(
        id: '5',
        heading: 'HOT AIR',
        description:
            'Saturn\'s atmosphere is made up mostly of hydrogen (H2) and helium (He).',
      ),
      FactModel(
        id: '6',
        heading: 'MINI SOLAR SYSTEM',
        description:
            'Saturn has 53 known moons with an additional 29 moons awaiting confirmation of their discovery—that is a total of 82 moons.',
      ),
      FactModel(
        id: '7',
        heading: 'RARE DESTINATION',
        description:
            'Few missions have visited Saturn: Pioneer 11 and Voyagers 1 and 2 flew by; But Cassini orbited Saturn 294 times from 2004 to 2017.',
      ),
      FactModel(
        id: '8',
        heading: 'LIFELESS BEHEMOTH',
        description:
            'Saturn cannot support life as we know it, but some of Saturn\'s moons have conditions that might support life.',
      ),
      FactModel(
        id: '9',
        heading: 'ADD A DASH OF EARTH',
        description:
            'About two tons of Saturn\'s mass came from Earth—the Cassini spacecraft was intentionally vaporized in Saturn\'s atmosphere in 2017.',
      ),
    ],
  ),
  const PlanetModel(
    id: '7',
    name: 'Uranus',
    credits: 'nasa',
    imgUrl: ['assets/7.png'],
    description:
        'Uranus is the seventh planet from the Sun, and has the third-largest diameter in our solar system. It was the first planet found with the aid of a telescope, Uranus was discovered in 1781 by astronomer William Herschel, although he originally thought it was either a comet or a star.It was two years later that the object was universally accepted as a new planet, in part because of observations by astronomer Johann Elert Bode. Herschel tried unsuccessfully to name his discovery Georgium Sidus after King George III. Instead, the scientific community accepted Bode\'s suggestion to name it Uranus, the Greek god of the sky, as suggested by Bode.​',
    lengthOfYear: '84 Earth Years (30,687 Earth Days)',
    gravity: ' 8.87 m/s²',
    distanceFromSun: '19.8 AU',
    noOfMoons: '27',
    facts: [
      FactModel(
        id: '1',
        heading: 'HUGE',
        description:
            'Uranus is about four times wider than Earth. If Earth were a large apple, Uranus would be the size of a basketball.',
      ),
      FactModel(
        id: '2',
        heading: 'SHORT-ISH DAY, LONGISH YEAR',
        description:
            'Uranus takes about 17 hours to rotate once (a Uranian day), and about 84 Earth years to complete an orbit of the Sun (a Uranian year).',
      ),
      FactModel(
        id: '3',
        heading: 'ICE GIANT',
        description:
            'Uranus is an ice giant. Most of its mass is a hot, dense fluid of "icy" materials – water, methane and ammonia – above a small rocky core.',
      ),
      FactModel(
        id: '4',
        heading: 'GASSY',
        description:
            'Uranus has an atmosphere made mostly of molecular hydrogen and atomic helium, with a small amount of methane.',
      ),
      FactModel(
        id: '5',
        heading: 'THE OTHER RINGED WORLD',
        description:
            'Uranus has 13 known rings. The inner rings are narrow and dark and the outer rings are brightly colored.',
      ),
      FactModel(
        id: '6',
        heading: 'A BIT LONELY',
        description:
            'Voyager 2 is the only spacecraft to fly by Uranus. No spacecraft has orbited this distant planet to study it at length and up close.',
      ),
      FactModel(
        id: '7',
        heading: 'LIFELESS',
        description: 'Uranus cannot support life as we know it.',
      ),
      FactModel(
        id: '8',
        heading: 'ONE COOL FACT',
        description:
            'Like Venus, Uranus rotates east to west. But Uranus is unique in that it rotates on its side.',
      ),
    ],
  ),
  const PlanetModel(
    id: '8',
    name: 'Neptune',
    credits: 'nasa',
    imgUrl: ['assets/8.png'],
    description:
        'Dark, cold, and whipped by supersonic winds, ice giant Neptune is the eighth and most distant planet in our solar system.More than 30 times as far from the Sun as Earth, Neptune is the only planet in our solar system not visible to the naked eye and the first predicted by mathematics before its discovery. In 2011 Neptune completed its first 165-year orbit since its discovery in 1846.NASA\'s Voyager 2 is the only spacecraft to have visited Neptune up close. It flew past in 1989 on its way out of the solar system.',
    lengthOfYear: '164.81 Earth Years (60,190 Earth Days)',
    gravity: ' 11.15 m/s²',
    distanceFromSun: '30.1 AU',
    noOfMoons: '14',
    facts: [
      FactModel(
        id: '1',
        heading: 'GIANT',
        description:
            'Neptune is about four times wider than Earth. If Earth were a large apple, Neptune would be the size of a basketball.',
      ),
      FactModel(
        id: '2',
        heading: 'SHORT DAY, LONG YEAR',
        description:
            'Neptune takes about 16 hours to rotate once (a Neptunian day), and about 165 Earth years to orbit the sun (a Neptunian year).',
      ),
      FactModel(
        id: '3',
        heading: 'ICE GIANT',
        description:
            'Neptune is an ice giant. Most of its mass is a hot, dense fluid of "icy" materials – water, methane and ammonia – above a small rocky core.',
      ),
      FactModel(
        id: '4',
        heading: 'GASSY',
        description:
            'Neptune\'s atmosphere is made up mostly of molecular hydrogen, atomic helium and methane.',
      ),
      FactModel(
        id: '5',
        heading: 'FAINT RINGS',
        description:
            'Neptune has at least five main rings and four more ring arcs, which are clumps of dust and debris likely formed by the gravity of a nearby moon.',
      ),
      FactModel(
        id: '6',
        heading: 'ONE VOYAGE THERE',
        description:
            'Voyager 2 is the only spacecraft to have visited Neptune. No spacecraft has orbited this distant planet to study it at length and up close.',
      ),
      FactModel(
        id: '7',
        heading: 'ONE COOL FACT',
        description:
            'Because of dwarf planet Pluto\'s elliptical orbit, Pluto is sometimes closer to the Sun (and us) than Neptune is.',
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// Static data (moved from app/data/articles_data.dart)
// ---------------------------------------------------------------------------

final List<ArticleModel> _articles = [
  const ArticleModel(
    id: '1',
    heading: 'Origin of the Universe',
    description:
        'The universe is believed to have originated about 15 billion years ago as a dense, hot globule of gas expanding rapidly outward. At that time, the universe contained nothing but hydrogen and a small amount of helium. There were no stars and no planets. The first stars probably began to form out of hydrogen when the universe was about 100 million years old. This is how our Sun originated about 4.49 billion years ago.',
    imgUrl: ['assets/origin.png'],
    imgCredits: ['NASA'],
    paragraphs: [
      ParagraphModel(
        id: '1',
        heading: 'DARK MATTER',
        imgUrl: 'assets/dark-matter.jpg',
        description:
            'In 1992, instruments aboard the Cosmic Background Explorer (COBE) satellite showed that 99.97 percent of the energy of the universe was released within the first year of its origin. This evidence seems to confirm the Big Bang theory, which holds that the universe originated from a single violent explosion (a big bang) of a very small amount of matter of extremely high density and temperature.Astronomers also theorize that 99% of the matter in the universe is invisible, or dark matter, composed of some kind of matter that is difficult to detect.',
      ),
    ],
  ),
  const ArticleModel(
    id: '2',
    heading: 'Big Bang Theory',
    description:
        'How was our Universe created? How did it become the seemingly limitless space we see today? And what will happen to it in the future? These are the kinds of questions that have puzzled philosophers and researchers since the dawn of time, leading to some rather strange and fascinating views. Scientists, astronomers, and cosmologists today agree that the Universe as we know it was born in a huge explosion that created not only the bulk of matter, but also the physical rules that govern our ever-expanding universe.This is known as The Big Bang Theory.',
    imgUrl: ['assets/1-whatisthebig.png'],
    imgCredits: ['bicepkeck.org'],
    paragraphs: [
      ParagraphModel(
        id: '1',
        heading: 'WHAT WAS THE BIG BANG?',
        imgUrl: 'assets/big-bang-to-present-e1591735093221.jpg',
        description:
            'The Big Bang Theory is the leading explanation for how the universe began. Simply put, it says the universe as we know it started with an infinitely hot and dense single point that inflated and stretched — first at unimaginable speeds, and then at a more measurable rate — over the next 13.8 billion years to the still-expanding cosmos that we know today.Existing technology doesn\'t yet allow astronomers to literally peer back at the universe\'s birth, much of what we understand about the Big Bang comes from mathematical formulas and models. Astronomers can, however, see the "echo" of the expansion through a phenomenon known as the cosmic microwave background.',
      ),
      ParagraphModel(
        id: '2',
        heading: 'THE BIRTH OF THE UNIVERSE',
        description:
            'Around 13.7 billion years ago, everything in the entire universe was condensed in an infinitesimally small singularity, a point of infinite denseness and heat. Suddenly, an explosive expansion began, ballooning our universe outwards faster than the speed of light. This was a period of cosmic inflation that lasted mere fractions of a second — about 10^-32 of a second, according to physicist Alan Guth\'s 1980 theory that changed the way we think about the Big Bang forever.When cosmic inflation came to a sudden and still-mysterious end, the more classic descriptions of the Big Bang took hold. A flood of matter and radiation, known as "reheating," began populating our universe with the stuff we know today: particles, atoms, the stuff that would become stars and galaxies and so on.',
      ),
    ],
  ),
  const ArticleModel(
    id: '3',
    heading: 'Steady State Theory',
    description:
        'The Big Bang theory states that the Universe originated from an incredibly hot and dense state 13.7 billion years ago and has been expanding and cooling ever since. It is now generally accepted by most cosmologists. However, this hasn\'t always been the case and for a while the Steady State theory was very popular. This theory was developed in 1948 by Fred Hoyle (1915-2001), Herman Bondi (1919-2005) and Thomas Gold (1920-2004) as an alternative to the Big Bang to explain the origin and expansion of the Universe. At the heart of the Steady State theory is the Perfect Cosmological Principle. This states that the Universe is infinite in extent, infinitely old and, taken as a whole, it is the same in all directions and at all times in the past and at all times in the future.  In other words, the Universe doesn\'t evolve or change over time.The theory does acknowledge that change takes place on a smaller scale.  If we take a small region of the Universe, such as the neighbourhood of the Sun, it does change over time as individual stars burn up their fuel and die, eventually becoming objects such as black dwarfs, neutrons stars and black holes.  The Steady State state theory proposes that new stars are continually created all the time at the rate needed to replace the stars which have used up their fuel and have stopped shining. So, if we take a large enough region of space, and by large we mean tens of millions of light years across, the average amount of light emitted doesn\'t change over time.',
    imgUrl: ['assets/theory.png'],
    imgCredits: ['bicepkeck.org'],
    paragraphs: [
      ParagraphModel(
        id: '1',
        heading: 'Decline of the Steady State theory',
        description:
            'The Steady State theory was very popular in the 1950s. However, evidence against the theory began to emerge during the early 1960s. Firstly, observations  taken with radio telescopes showed that there were more radio sources a long distance away from us than would be predicted by the theory.  By a long distance, I mean billions of light years. Because of the times it takes light to reach us then, when we look at objects billions of light years from us, we are looking back billions of years in time.  So what these observations were saying is that there were more cosmic radio sources billions of years ago than there are now. This would suggest that the Universe is changing over time which contradicts the Steady State theory.Another piece of evidence  to discredit the theory emerged in 1963, when a new class of astronomical objects called quasars was discovered. These are incredibly bright objects which can be up to 1,000 times the brightness of the Milky Way, but are very small when compared to size of a galaxy. Quasars are only found at great distances from us, meaning that the light from them was emitted billions of light years ago. The fact that quasars are only found in the early Universe provides strong evidence that the Universe has changed over time.However the real the nail in the coffin of the Steady State theory was the discovery in 1965 of the cosmic microwave background radiation. This is a weak background radiation which fills the whole of space and is the same in all directions. In the Big Bang theory this radiation is a relic or snapshot from the time the Universe was young and hot and was predicted  before it was discovered. However, in the Steady State theory it is almost impossible to explain the origin of this radiation.',
      ),
      ParagraphModel(
        id: '2',
        heading: 'In the words of Stephen Hawking:',
        description:
            '‘the Steady State theory was what Karl Popper would call a good scientific theory: it made definite predictions, which could be tested by observation, and possibly falsified. Unfortunately for the theory, they were falsified’ ',
      ),
    ],
  ),
];
