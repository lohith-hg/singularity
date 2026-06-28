class NeoEntity {
  final String name;
  final String closeApproachDate;
  final String missDistanceKm;
  final String velocityKmh;
  final double diameterMaxKm;
  final bool isHazardous;

  const NeoEntity({
    required this.name,
    required this.closeApproachDate,
    required this.missDistanceKm,
    required this.velocityKmh,
    required this.diameterMaxKm,
    required this.isHazardous,
  });
}
