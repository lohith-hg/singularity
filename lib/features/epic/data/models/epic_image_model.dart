import 'dart:convert';
import '../../../../core/constants/nasa_api.dart';
import '../../domain/entities/epic_image_entity.dart';

List<EpicImageModel> epicImageListFromJson(String str) =>
    List<EpicImageModel>.from(
      (json.decode(str) as List).map((x) => EpicImageModel.fromJson(x)),
    );

// Parses the /EPIC/api/natural/all response: [{"date":"2024-01-15"}, ...]
List<String> epicDatesFromJson(String str) => List<String>.from(
  (json.decode(str) as List).map((x) => (x as Map)['date'] as String),
);

class EpicImageModel {
  final String identifier;
  final String caption;
  final String imageUrl;
  final String date;
  final double lat;
  final double lon;

  const EpicImageModel({
    required this.identifier,
    required this.caption,
    required this.imageUrl,
    required this.date,
    required this.lat,
    required this.lon,
  });

  factory EpicImageModel.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date'] as String; // "2024-01-15 00:31:45"
    final dateParts = dateStr.split(' ').first.split('-');
    final yyyy = dateParts[0];
    final mm = dateParts[1];
    final dd = dateParts[2];
    final imageName = json['image'] as String;
    final imageUrl =
        'https://api.nasa.gov/EPIC/archive/natural/$yyyy/$mm/$dd/png/$imageName.png?api_key=${NasaApi.apiKey}';

    final centroid = json['centroid_coordinates'] as Map<String, dynamic>;

    return EpicImageModel(
      identifier: json['identifier'] as String,
      caption: json['caption'] as String,
      imageUrl: imageUrl,
      date: dateStr,
      lat: (centroid['lat'] as num).toDouble(),
      lon: (centroid['lon'] as num).toDouble(),
    );
  }

  EpicImageEntity toEntity() => EpicImageEntity(
    identifier: identifier,
    caption: caption,
    imageUrl: imageUrl,
    date: date,
    lat: lat,
    lon: lon,
  );
}
