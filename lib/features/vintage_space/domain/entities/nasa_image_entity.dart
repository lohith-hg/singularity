import 'package:equatable/equatable.dart';

// Flattened version of the nested HistoryAlbum model.
// The view uses image.title instead of historyPictures[i].data![0].title!
class NasaImageEntity extends Equatable {
  final String title;
  final String description;
  final String imageUrl;
  final DateTime dateCreated;

  const NasaImageEntity({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.dateCreated,
  });

  @override
  List<Object?> get props => [imageUrl, dateCreated];
}
