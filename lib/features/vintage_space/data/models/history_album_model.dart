import '../../domain/entities/nasa_image_entity.dart';

class HistoryAlbumModel {
  final String? title;
  final String? description;
  final String? imageUrl;
  final DateTime? dateCreated;

  const HistoryAlbumModel({
    this.title,
    this.description,
    this.imageUrl,
    this.dateCreated,
  });

  factory HistoryAlbumModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>?;
    final linksList = json['links'] as List<dynamic>?;

    final data = dataList?.isNotEmpty == true
        ? dataList!.first as Map<String, dynamic>
        : null;
    final link = linksList?.isNotEmpty == true
        ? linksList!.first as Map<String, dynamic>
        : null;

    return HistoryAlbumModel(
      title: data?['title'] as String?,
      description: data?['description'] as String?,
      imageUrl: link?['href'] as String?,
      dateCreated: data?['date_created'] != null
          ? DateTime.tryParse(data!['date_created'] as String)
          : null,
    );
  }

  // Returns null if the item lacks required fields — filtered out in the repository.
  NasaImageEntity? toEntity() {
    if (title == null || description == null || imageUrl == null || dateCreated == null) {
      return null;
    }
    return NasaImageEntity(
      title: title!,
      description: description!,
      imageUrl: imageUrl!,
      dateCreated: dateCreated!,
    );
  }
}
