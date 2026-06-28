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
  final String thumbnailUrl;

  ApodModel({
    required this.copyright,
    required this.date,
    required this.explanation,
    required this.hdurl,
    required this.mediaType,
    required this.serviceVersion,
    required this.title,
    required this.url,
    this.thumbnailUrl = '',
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
    thumbnailUrl: json['thumbnail_url'] as String? ?? '',
  );

  factory ApodModel.fromEntity(ApodEntity e) => ApodModel(
    copyright: e.copyright,
    date: e.date,
    explanation: e.explanation,
    hdurl: e.hdurl,
    mediaType: e.mediaType,
    serviceVersion: e.serviceVersion,
    title: e.title,
    url: e.url,
    thumbnailUrl: e.thumbnailUrl,
  );

  Map<String, dynamic> toMap() => {
    'copyright': copyright,
    'date':
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
    'explanation': explanation,
    'hdurl': hdurl,
    'media_type': mediaType,
    'service_version': serviceVersion,
    'title': title,
    'url': url,
    'thumbnail_url': thumbnailUrl,
  };

  ApodEntity toEntity() => ApodEntity(
    copyright: copyright,
    date: date,
    explanation: explanation,
    hdurl: hdurl,
    mediaType: mediaType,
    serviceVersion: serviceVersion,
    title: title,
    url: url,
    thumbnailUrl: thumbnailUrl,
  );
}
