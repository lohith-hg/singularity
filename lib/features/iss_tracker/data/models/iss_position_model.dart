import 'dart:convert';
import '../../domain/entities/iss_position_entity.dart';

IssPositionModel issPositionFromJson(String str) =>
    IssPositionModel.fromJson(json.decode(str));

class IssPositionModel {
  final double lat;
  final double lon;
  final int timestamp;
  final double velocity;
  final double altitude;
  final String visibility;

  const IssPositionModel({
    required this.lat,
    required this.lon,
    required this.timestamp,
    required this.velocity,
    required this.altitude,
    required this.visibility,
  });

  factory IssPositionModel.fromJson(Map<String, dynamic> json) {
    final position = json['iss_position'] is Map<String, dynamic>
        ? json['iss_position'] as Map<String, dynamic>
        : json;
    return IssPositionModel(
      lat: _toDouble(position['latitude']),
      lon: _toDouble(position['longitude']),
      timestamp: _toInt(json['timestamp']),
      velocity: _toDouble(json['velocity']),
      altitude: _toDouble(json['altitude']),
      visibility: json['visibility'] as String? ?? '',
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  IssPositionEntity toEntity() => IssPositionEntity(
    lat: lat,
    lon: lon,
    timestamp: timestamp,
    velocity: velocity,
    altitude: altitude,
    visibility: visibility,
  );
}
