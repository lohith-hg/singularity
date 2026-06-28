import 'dart:convert';
import '../../domain/entities/exoplanet_entity.dart';

List<ExoplanetModel> exoplanetListFromJson(String str) =>
    List<ExoplanetModel>.from(
      (json.decode(str) as List).map((x) => ExoplanetModel.fromJson(x)),
    );

class ExoplanetModel {
  final String name;
  final double? radiusEarth;
  final double? massEarth;
  final double? orbitalPeriodDays;
  final double? distanceParsecs;
  final int? discoveryYear;

  const ExoplanetModel({
    required this.name,
    this.radiusEarth,
    this.massEarth,
    this.orbitalPeriodDays,
    this.distanceParsecs,
    this.discoveryYear,
  });

  factory ExoplanetModel.fromJson(Map<String, dynamic> json) => ExoplanetModel(
    name: json['pl_name'] as String? ?? 'Unknown',
    radiusEarth: _toDouble(json['pl_rade']),
    massEarth: _toDouble(json['pl_bmasse']),
    orbitalPeriodDays: _toDouble(json['pl_orbper']),
    distanceParsecs: _toDouble(json['sy_dist']),
    discoveryYear: _toInt(json['disc_year']),
  );

  static double? _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  ExoplanetEntity toEntity() => ExoplanetEntity(
    name: name,
    radiusEarth: radiusEarth,
    massEarth: massEarth,
    orbitalPeriodDays: orbitalPeriodDays,
    distanceParsecs: distanceParsecs,
    discoveryYear: discoveryYear,
  );
}
