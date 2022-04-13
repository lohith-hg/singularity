import 'package:singularity/data/article.dart';

List<Article> universeArticles = [
  Article(
    id: '1',
    heading: 'Origin of the Universe',
    discription:
        'The universe is believed to have originated about 15 billion years ago as a dense, hot globule of gas expanding rapidly outward. At that time, the universe contained nothing but hydrogen and a small amount of helium. There were no stars and no planets. The first stars probably began to form out of hydrogen when the universe was about 100 million years old. This is how our Sun originated about 4.49 billion years ago.',
    imgUrl: ['assets/origin.png'],
    imgCredits: ['NASA'],
    paragraphs: [
      Paragraph(
        id: '1',
        heading: 'DARK MATTER',
        imgUrl: 'assets/dark-matter.jpg',
        discription:
            'In 1992, instruments aboard the Cosmic Background Explorer (COBE) satellite showed that 99.97 percent of the energy of the universe was released within the first year of its origin. This evidence seems to confirm the Big Bang theory, which holds that the universe originated from a single violent explosion (a big bang) of a very small amount of matter of extremely high density and temperature.Astronomers also theorize that 99% of the matter in the universe is invisible, or dark matter, composed of some kind of matter that is difficult to detect.',
      ),
    ],
  ),
  Article(
    id: '2',
    heading: 'Big Bang Theory',
    discription:
        'How was our Universe created? How did it become the seemingly limitless space we see today? And what will happen to it in the future? These are the kinds of questions that have puzzled philosophers and researchers since the dawn of time, leading to some rather strange and fascinating views. Scientists, astronomers, and cosmologists today agree that the Universe as we know it was born in a huge explosion that created not only the bulk of matter, but also the physical rules that govern our ever-expanding universe.This is known as The Big Bang Theory.',
    imgUrl: ['assets/1-whatisthebig.png'],
    imgCredits: ['bicepkeck.org'],
    paragraphs: [
      Paragraph(
        id: '1',
        heading: 'WHAT WAS THE BIG BANG?',
        imgUrl: 'assets/big-bang-to-present-e1591735093221.jpg',
        discription:
            'The Big Bang Theory is the leading explanation for how the universe began. Simply put, it says the universe as we know it started with an infinitely hot and dense single point that inflated and stretched — first at unimaginable speeds, and then at a more measurable rate — over the next 13.8 billion years to the still-expanding cosmos that we know today.Existing technology doesn\'t yet allow astronomers to literally peer back at the universe\'s birth, much of what we understand about the Big Bang comes from mathematical formulas and models. Astronomers can, however, see the "echo" of the expansion through a phenomenon known as the cosmic microwave background.',
      ),
      Paragraph(
        id: '2',
        heading: 'THE BIRTH OF THE UNIVERSE',
        discription:
            'Around 13.7 billion years ago, everything in the entire universe was condensed in an infinitesimally small singularity, a point of infinite denseness and heat. Suddenly, an explosive expansion began, ballooning our universe outwards faster than the speed of light. This was a period of cosmic inflation that lasted mere fractions of a second — about 10^-32 of a second, according to physicist Alan Guth’s 1980 theory that changed the way we think about the Big Bang forever.When cosmic inflation came to a sudden and still-mysterious end, the more classic descriptions of the Big Bang took hold. A flood of matter and radiation, known as “reheating,” began populating our universe with the stuff we know today: particles, atoms, the stuff that would become stars and galaxies and so on.',
      )
    ],
  ),
  Article(
    id: '3',
    heading: 'Steady State Theory',
    discription:
        'The Big Bang theory states that the Universe originated from an incredibly hot and dense state 13.7 billion years ago and has been expanding and cooling ever since. It is now generally accepted by most cosmologists. However, this hasn’t always been the case and for a while the Steady State theory was very popular. This theory was developed in 1948 by Fred Hoyle (1915-2001), Herman Bondi (1919-2005) and Thomas Gold (1920-2004) as an alternative to the Big Bang to explain the origin and expansion of the Universe. At the heart of the Steady State theory is the Perfect Cosmological Principle. This states that the Universe is infinite in extent, infinitely old and, taken as a whole, it is the same in all directions and at all times in the past and at all times in the future.  In other words, the Universe doesn’t evolve or change over time.The theory does acknowledge that change takes place on a smaller scale.  If we take a small region of the Universe, such as the neighbourhood of the Sun, it does change over time as individual stars burn up their fuel and die, eventually becoming objects such as black dwarfs, neutrons stars and black holes.  The Steady State state theory proposes that new stars are continually created all the time at the rate needed to replace the stars which have used up their fuel and have stopped shining. So, if we take a large enough region of space, and by large we mean tens of millions of light years across, the average amount of light emitted doesn’t change over time.',
    imgUrl: ['assets/theory.png'],
    imgCredits: ['bicepkeck.org'],
    paragraphs: [
      Paragraph(
        id: '1',
        heading: 'Decline of the Steady State theory',
        discription:
            'The Steady State theory was very popular in the 1950s. However, evidence against the theory began to emerge during the early 1960s. Firstly, observations  taken with radio telescopes showed that there were more radio sources a long distance away from us than would be predicted by the theory.  By a long distance, I mean billions of light years. Because of the times it takes light to reach us then, when we look at objects billions of light years from us, we are looking back billions of years in time.  So what these observations were saying is that there were more cosmic radio sources billions of years ago than there are now. This would suggest that the Universe is changing over time which contradicts the Steady State theory.Another piece of evidence  to discredit the theory emerged in 1963, when a new class of astronomical objects called quasars was discovered. These are incredibly bright objects which can be up to 1,000 times the brightness of the Milky Way, but are very small when compared to size of a galaxy. Quasars are only found at great distances from us, meaning that the light from them was emitted billions of light years ago. The fact that quasars are only found in the early Universe provides strong evidence that the Universe has changed over time.However the real the nail in the coffin of the Steady State theory was the discovery in 1965 of the cosmic microwave background radiation. This is a weak background radiation which fills the whole of space and is the same in all directions. In the Big Bang theory this radiation is a relic or snapshot from the time the Universe was young and hot and was predicted  before it was discovered. However, in the Steady State theory it is almost impossible to explain the origin of this radiation.',
      ),
      Paragraph(
        id: '2',
        heading: 'In the words of Stephen Hawking:',
        discription:
            '‘the Steady State theory was what Karl Popper would call a good scientific theory: it made definite predictions, which could be tested by observation, and possibly falsified. Unfortunately for the theory, they were falsified’ ',
      )
    ],
  )
];
