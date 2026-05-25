import '../../domain/entities/article_entity.dart';
import '../../domain/entities/paragraph_entity.dart';

class ParagraphModel {
  final String id;
  final String heading;
  final String? imgUrl;
  final String description;

  const ParagraphModel({
    required this.id,
    required this.heading,
    this.imgUrl,
    required this.description,
  });

  ParagraphEntity toEntity() => ParagraphEntity(
    id: id,
    heading: heading,
    imgUrl: imgUrl,
    description: description,
  );
}

class ArticleModel {
  final String id;
  final String heading;
  final String description;
  final List<String> imgUrl;
  final List<String> imgCredits;
  final List<ParagraphModel> paragraphs;

  const ArticleModel({
    required this.id,
    required this.heading,
    required this.description,
    required this.imgUrl,
    required this.imgCredits,
    required this.paragraphs,
  });

  ArticleEntity toEntity() => ArticleEntity(
    id: id,
    heading: heading,
    description: description,
    imgUrl: imgUrl,
    imgCredits: imgCredits,
    paragraphs: paragraphs.map((p) => p.toEntity()).toList(),
  );
}
