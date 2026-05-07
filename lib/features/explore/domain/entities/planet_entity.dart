import 'package:equatable/equatable.dart';
import 'fact_entity.dart';

class PlanetEntity extends Equatable {
  final String id;
  final String name;
  final String credits;
  final List<String> imgUrl;
  final String description;
  final String lengthOfYear;
  final String gravity;
  final String distanceFromSun;
  final String noOfMoons;
  final List<FactEntity> facts;

  const PlanetEntity({
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

  @override
  List<Object?> get props => [id, name];
}
