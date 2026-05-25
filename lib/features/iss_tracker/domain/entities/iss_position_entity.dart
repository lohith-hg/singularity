class IssPositionEntity {
  final double lat;
  final double lon;
  final int timestamp;
  final double velocity;
  final double altitude;
  final String visibility;

  const IssPositionEntity({
    required this.lat,
    required this.lon,
    required this.timestamp,
    this.velocity = 27576,
    this.altitude = 408,
    this.visibility = '',
  });
}
