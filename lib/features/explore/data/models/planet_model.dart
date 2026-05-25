import '../../domain/entities/fact_entity.dart';
import '../../domain/entities/planet_entity.dart';

class FactModel {
  final String id;
  final String heading;
  final String description;

  const FactModel({
    required this.id,
    required this.heading,
    required this.description,
  });

  FactEntity toEntity() =>
      FactEntity(id: id, heading: heading, description: description);
}

class PlanetModel {
  final String id;
  final String name;
  final String credits;
  final List<String> imgUrl;
  final String description;
  final String lengthOfYear;
  final String gravity;
  final String distanceFromSun;
  final String noOfMoons;
  final List<FactModel> facts;

  const PlanetModel({
    required this.id,
    required this.name,
    required this.credits,
    required this.imgUrl,
    required this.description,
    required this.lengthOfYear,
    required this.gravity,
    required this.distanceFromSun,
    required this.noOfMoons,
    required this.facts,
  });

  PlanetEntity toEntity() => PlanetEntity(
    id: id,
    name: name,
    credits: credits,
    imgUrl: imgUrl,
    description: description,
    lengthOfYear: lengthOfYear,
    gravity: gravity,
    distanceFromSun: distanceFromSun,
    noOfMoons: noOfMoons,
    facts: facts.map((f) => f.toEntity()).toList(),
  );
}
