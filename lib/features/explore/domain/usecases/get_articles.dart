import '../../../../core/usecases/usecase.dart';
import '../entities/article_entity.dart';
import '../repositories/explore_repository.dart';

class GetArticles implements UseCase<List<ArticleEntity>, NoParams> {
  final ExploreRepository repository;
  GetArticles(this.repository);

  @override
  Future<List<ArticleEntity>> call(NoParams params) {
    return repository.getArticles();
  }
}
