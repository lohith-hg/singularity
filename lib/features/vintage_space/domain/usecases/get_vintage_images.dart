import 'dart:math';
import '../../../../core/constants/topics.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/nasa_image_entity.dart';
import '../repositories/nasa_images_repository.dart';

// Picks 8 random topics and fetches them in parallel with Future.wait.
// This is ~4x faster than the original sequential for-loop in the GetX controller.
class GetVintageImages implements UseCase<List<NasaImageEntity>, NoParams> {
  final NasaImagesRepository repository;
  GetVintageImages(this.repository);

  @override
  Future<List<NasaImageEntity>> call(NoParams params) async {
    final shuffledTopics = List<String>.from(astronomyTopics)
      ..shuffle(Random());
    final selectedTopics = shuffledTopics.take(8).toList();

    final results = await Future.wait(
      selectedTopics.map((topic) => repository.getImagesByTopic(topic)),
    );

    final allImages = results.expand((list) => list).toList()..shuffle();
    return allImages;
  }
}
