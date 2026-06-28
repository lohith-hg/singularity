import 'dart:convert';

import '../../domain/entities/space_weather_event_entity.dart';

List<SpaceWeatherEventModel> spaceWeatherEventListFromCached(String str) =>
    (jsonDecode(str) as List)
        .map(
          (x) => SpaceWeatherEventModel.fromCached(x as Map<String, dynamic>),
        )
        .toList();

String spaceWeatherEventListToJson(List<SpaceWeatherEventModel> events) =>
    jsonEncode(events.map((e) => e.toJson()).toList());

class SpaceWeatherEventModel {
  final String type;
  final String id;
  final String time;
  final String description;
  final double? kpIndex;

  const SpaceWeatherEventModel({
    required this.type,
    required this.id,
    required this.time,
    required this.description,
    this.kpIndex,
  });

  factory SpaceWeatherEventModel.fromCme(Map<String, dynamic> json) {
    final note = json['note'] as String? ?? '';
    return SpaceWeatherEventModel(
      type: 'CME',
      id: json['activityID'] as String? ?? '',
      time: json['startTime'] as String? ?? '',
      description: note.length > 100 ? note.substring(0, 100) : note,
    );
  }

  factory SpaceWeatherEventModel.fromFlr(Map<String, dynamic> json) {
    final classType = json['classType'] as String? ?? '';
    final note = json['note'] as String? ?? '';
    final truncatedNote = note.length > 60 ? note.substring(0, 60) : note;
    return SpaceWeatherEventModel(
      type: 'FLR',
      id: json['flrID'] as String? ?? '',
      time: json['beginTime'] as String? ?? '',
      description: '$classType: $truncatedNote',
    );
  }

  factory SpaceWeatherEventModel.fromGst(Map<String, dynamic> json) {
    final allKpIndex = json['allKpIndex'] as List? ?? [];
    double? kp;
    String desc = 'Geomagnetic Storm';

    if (allKpIndex.isNotEmpty) {
      final first = allKpIndex.first as Map<String, dynamic>;
      kp = (first['kpIndex'] as num?)?.toDouble();
      if (kp != null) desc = 'KP-Index: $kp';
    }

    return SpaceWeatherEventModel(
      type: 'GST',
      id: json['gstID'] as String? ?? '',
      time: json['startTime'] as String? ?? '',
      description: desc,
      kpIndex: kp,
    );
  }

  factory SpaceWeatherEventModel.fromSep(Map<String, dynamic> json) {
    final instruments = json['instruments'] as List? ?? [];
    final names = instruments
        .map(
          (i) => (i as Map<String, dynamic>)['displayName'] as String? ?? '',
        )
        .join(', ');
    return SpaceWeatherEventModel(
      type: 'SEP',
      id: json['sepID'] as String? ?? '',
      time: json['eventTime'] as String? ?? '',
      description: names.isNotEmpty ? names : 'Solar Energetic Particles',
    );
  }

  /// Deserialise from the flat cached format written by [toJson].
  factory SpaceWeatherEventModel.fromCached(Map<String, dynamic> json) =>
      SpaceWeatherEventModel(
        type: json['type'] as String,
        id: json['id'] as String,
        time: json['time'] as String,
        description: json['description'] as String,
        kpIndex: (json['kpIndex'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'time': time,
        'description': description,
        'kpIndex': kpIndex,
      };

  SpaceWeatherEventEntity toEntity() => SpaceWeatherEventEntity(
        type: type,
        id: id,
        time: time,
        description: description,
        kpIndex: kpIndex,
      );
}
