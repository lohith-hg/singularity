import '../../../shared/entities/apod_entity.dart';
import '../../domain/entities/saved_item_entity.dart';

class SavedItemModel extends SavedItemEntity {
  const SavedItemModel({required super.apod, required super.savedAt});

  factory SavedItemModel.fromMap(Map<String, dynamic> map) {
    final apodMap = map['apod'] as Map<String, dynamic>;
    return SavedItemModel(
      apod: ApodEntity(
        copyright: apodMap['copyright'] as String? ?? '',
        date: DateTime.parse(apodMap['date'] as String),
        explanation: apodMap['explanation'] as String? ?? '',
        hdurl: apodMap['hdurl'] as String? ?? '',
        mediaType: apodMap['mediaType'] as String? ?? 'image',
        serviceVersion: apodMap['serviceVersion'] as String? ?? '',
        title: apodMap['title'] as String? ?? '',
        url: apodMap['url'] as String? ?? '',
        thumbnailUrl: apodMap['thumbnailUrl'] as String? ?? '',
      ),
      savedAt: DateTime.parse(map['savedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'apod': {
        'copyright': apod.copyright,
        'date': apod.date.toIso8601String(),
        'explanation': apod.explanation,
        'hdurl': apod.hdurl,
        'mediaType': apod.mediaType,
        'serviceVersion': apod.serviceVersion,
        'title': apod.title,
        'url': apod.url,
        'thumbnailUrl': apod.thumbnailUrl,
      },
      'savedAt': savedAt.toIso8601String(),
    };
  }
}
