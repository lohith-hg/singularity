import 'package:flutter_test/flutter_test.dart';
import 'package:singularity/features/vintage_space/domain/entities/nasa_image_entity.dart';
import 'package:singularity/features/vintage_space/domain/repositories/nasa_images_repository.dart';
import 'package:singularity/features/vintage_space/domain/usecases/get_vintage_images.dart';
import 'package:singularity/features/vintage_space/domain/usecases/search_nasa_images.dart';
import 'package:singularity/features/vintage_space/presentation/bloc/vintage_space_bloc.dart';

void main() {
  test('search emits searching then loaded results', () async {
    final repository = _FakeImagesRepository(results: [_image('Apollo 11')]);
    final bloc = _bloc(repository);

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder([
        const VintageSpaceSearching('apollo'),
        VintageSpaceLoaded(images: [_image('Apollo 11')], query: 'apollo'),
      ]),
    );

    bloc.add(SearchVintageSpaceEvent(' apollo '));
    await expectation;
    await bloc.close();
  });

  test('search emits loaded with empty results', () async {
    final bloc = _bloc(_FakeImagesRepository());

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder([
        const VintageSpaceSearching('nothing'),
        const VintageSpaceLoaded(images: [], query: 'nothing'),
      ]),
    );

    bloc.add(SearchVintageSpaceEvent('nothing'));
    await expectation;
    await bloc.close();
  });

  test('search emits error when repository fails', () async {
    final bloc = _bloc(
      _FakeImagesRepository(error: Exception('Network failed')),
    );

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder([
        const VintageSpaceSearching('mars'),
        isA<VintageSpaceError>(),
      ]),
    );

    bloc.add(SearchVintageSpaceEvent('mars'));
    await expectation;
    await bloc.close();
  });

  test('empty search clears to initial state', () async {
    final bloc = _bloc(_FakeImagesRepository());

    final expectation = expectLater(
      bloc.stream,
      emits(const VintageSpaceInitial()),
    );

    bloc.add(SearchVintageSpaceEvent('   '));
    await expectation;
    await bloc.close();
  });
}

VintageSpaceBloc _bloc(_FakeImagesRepository repository) {
  return VintageSpaceBloc(
    getVintageImages: GetVintageImages(repository),
    searchNasaImages: SearchNasaImages(repository),
  );
}

NasaImageEntity _image(String title) {
  return NasaImageEntity(
    title: title,
    description: 'Archive image',
    imageUrl: 'https://example.com/$title.jpg',
    dateCreated: DateTime(1969, 7, 20),
  );
}

class _FakeImagesRepository implements NasaImagesRepository {
  _FakeImagesRepository({this.results = const [], this.error});

  final List<NasaImageEntity> results;
  final Object? error;

  @override
  Future<List<NasaImageEntity>> getImagesByTopic(String topic) async => [];

  @override
  Future<List<NasaImageEntity>> searchImages(String query) async {
    if (error != null) throw error!;
    return results;
  }
}
