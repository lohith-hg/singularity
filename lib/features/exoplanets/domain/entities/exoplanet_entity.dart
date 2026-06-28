class ExoplanetEntity {
  final String name;
  final double? radiusEarth;
  final double? massEarth;
  final double? orbitalPeriodDays;
  final double? distanceParsecs;
  final int? discoveryYear;

  const ExoplanetEntity({
    required this.name,
    this.radiusEarth,
    this.massEarth,
    this.orbitalPeriodDays,
    this.distanceParsecs,
    this.discoveryYear,
  });
}
