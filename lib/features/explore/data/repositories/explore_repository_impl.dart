import '../../domain/entities/article_entity.dart';
import '../../domain/entities/planet_entity.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/explore_local_datasource.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreLocalDataSource dataSource;
  ExploreRepositoryImpl(this.dataSource);

  @override
  Future<List<PlanetEntity>> getPlanets() async {
    final models = await dataSource.getPlanets();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ArticleEntity>> getArticles() async {
    final models = await dataSource.getArticles();
    return models.map((m) => m.toEntity()).toList();
  }
}
