import 'dart:convert';
import '../../domain/entities/neo_entity.dart';

List<NeoModel> neoListFromJson(String str) {
  final decoded = json.decode(str) as Map<String, dynamic>;
  final nearEarthObjects =
      decoded['near_earth_objects'] as Map<String, dynamic>;

  final allNeos = <NeoModel>[];
  for (final dateKey in nearEarthObjects.keys) {
    final dateNeos = (nearEarthObjects[dateKey] as List)
        .map((x) => NeoModel.fromJson(x as Map<String, dynamic>))
        .toList();
    allNeos.addAll(dateNeos);
  }
  return allNeos;
}

class NeoModel {
  final String name;
  final String closeApproachDate;
  final String missDistanceKm;
  final String velocityKmh;
  final double diameterMaxKm;
  final bool isHazardous;

  const NeoModel({
    required this.name,
    required this.closeApproachDate,
    required this.missDistanceKm,
    required this.velocityKmh,
    required this.diameterMaxKm,
    required this.isHazardous,
  });

  factory NeoModel.fromJson(Map<String, dynamic> json) {
    final closeApproachList = json['close_approach_data'] as List? ?? [];
    final closeApproach = closeApproachList.isNotEmpty
        ? closeApproachList.first as Map<String, dynamic>
        : <String, dynamic>{};

    final missDistance =
        (closeApproach['miss_distance'] as Map<String, dynamic>?)?['kilometers']
            as String? ??
        '0';
    final velocity =
        (closeApproach['relative_velocity']
                as Map<String, dynamic>?)?['kilometers_per_hour']
            as String? ??
        '0';
    final approachDate = closeApproach['close_approach_date'] as String? ?? '';

    final estimatedDiameter =
        (json['estimated_diameter'] as Map<String, dynamic>?)?['kilometers']
            as Map<String, dynamic>? ??
        {};
    final diameterMax =
        (estimatedDiameter['estimated_diameter_max'] as num?)?.toDouble() ??
        0.0;

    return NeoModel(
      name: json['name'] as String,
      closeApproachDate: approachDate,
      missDistanceKm: missDistance,
      velocityKmh: velocity,
      diameterMaxKm: diameterMax,
      isHazardous: json['is_potentially_hazardous_asteroid'] as bool? ?? false,
    );
  }

  NeoEntity toEntity() => NeoEntity(
    name: name,
    closeApproachDate: closeApproachDate,
    missDistanceKm: missDistanceKm,
    velocityKmh: velocityKmh,
    diameterMaxKm: diameterMaxKm,
    isHazardous: isHazardous,
  );
}
