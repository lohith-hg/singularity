import 'dart:convert';
import '../../../shared/entities/apod_entity.dart';

List<ApodModel> apodListFromJson(String str) =>
    List<ApodModel>.from(json.decode(str).map((x) => ApodModel.fromJson(x)));

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
        copyright: json['copyright'] ?? 'NASA',
        date: DateTime.parse(json['date']),
        explanation: json['explanation'],
        hdurl: json['hdurl'] ?? '',
        mediaType: json['media_type'],
        serviceVersion: json['service_version'],
        title: json['title'],
        url: json['url'],
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
