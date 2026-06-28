import 'dart:convert';
import '../../domain/entities/rover_photo_entity.dart';

List<RoverPhotoModel> roverPhotoListFromJson(String str) {
  final decoded = json.decode(str) as Map<String, dynamic>;
  final items = (decoded['collection']['items'] as List);
  return items
      .where((item) => (item['links'] as List?)?.isNotEmpty == true)
      .map((item) => RoverPhotoModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

class RoverPhotoModel {
  final String id;
  final String thumbnailUrl;
  final String originalUrl;
  final String title;
  final String date;
  final String description;

  const RoverPhotoModel({
    required this.id,
    required this.thumbnailUrl,
    required this.originalUrl,
    required this.title,
    required this.date,
    required this.description,
  });

  factory RoverPhotoModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List)[0] as Map<String, dynamic>;
    final links = json['links'] as List;

    String thumbnailUrl = links[0]['href'] as String;
    String originalUrl = thumbnailUrl;
    for (final link in links) {
      final rel = link['rel'] as String?;
      if (rel == 'alternate') thumbnailUrl = link['href'] as String;
      if (rel == 'canonical') originalUrl = link['href'] as String;
    }

    return RoverPhotoModel(
      id: data['nasa_id'] as String,
      thumbnailUrl: thumbnailUrl,
      originalUrl: originalUrl,
      title: data['title'] as String? ?? '',
      date: data['date_created'] as String? ?? '',
      description: data['description'] as String? ?? '',
    );
  }

  RoverPhotoEntity toEntity() => RoverPhotoEntity(
    id: id,
    thumbnailUrl: thumbnailUrl,
    originalUrl: originalUrl,
    title: title,
    date: date,
    description: description,
  );
}
