class EpicImageEntity {
  final String identifier;
  final String caption;
  final String imageUrl;
  final String date;
  final double lat;
  final double lon;

  const EpicImageEntity({
    required this.identifier,
    required this.caption,
    required this.imageUrl,
    required this.date,
    required this.lat,
    required this.lon,
  });
}
