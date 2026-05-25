class SpaceWeatherEventEntity {
  final String type;
  final String id;
  final String time;
  final String description;
  final double? kpIndex;

  const SpaceWeatherEventEntity({
    required this.type,
    required this.id,
    required this.time,
    required this.description,
    this.kpIndex,
  });
}
