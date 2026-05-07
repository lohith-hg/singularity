import '../entities/article_entity.dart';
import '../entities/planet_entity.dart';

// Domain contract: declares WHAT data the app needs.
// The data layer decides HOW to provide it.
abstract class ExploreRepository {
  Future<List<PlanetEntity>> getPlanets();
  Future<List<ArticleEntity>> getArticles();
}
