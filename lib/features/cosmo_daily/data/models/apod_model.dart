import 'dart:convert';
import '../../../shared/entities/apod_entity.dart';

List<ApodModel> apodListFromJson(String str) {
  final decoded = json.decode(str);
  final items = decoded is List ? decoded : [decoded];
  return items
      .whereType<Map<String, dynamic>>()
      .map(ApodModel.fromJson)
      .toList();
}

class ApodModel {
  final String copyright;
  final DateTime date;
  final String explanation;
  final String hdurl;
  final String mediaType;
  final String serviceVersion;
  final String title;
  final String url;

  ApodModel({
    required this.copyright,
    required this.date,
    required this.explanation,
    required this.hdurl,
    required this.mediaType,
    required this.serviceVersion,
    required this.title,
    required this.url,
  });

  factory ApodModel.fromJson(Map<String, dynamic> json) => ApodModel(
    copyright: json['copyright'] as String? ?? 'NASA',
    date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    explanation: json['explanation'] as String? ?? '',
    hdurl: json['hdurl'] as String? ?? '',
    mediaType: json['media_type'] as String? ?? 'image',
    serviceVersion: json['service_version'] as String? ?? 'v1',
    title: json['title'] as String? ?? 'Astronomy Picture of the Day',
    url: (json['url'] ?? json['thumbnail_url'] ?? '') as String,
  );

  ApodEntity toEntity() => ApodEntity(
    copyright: copyright,
    date: date,
    explanation: explanation,
    hdurl: hdurl,
    mediaType: mediaType,
    serviceVersion: serviceVersion,
    title: title,
    url: url,
  );
}
