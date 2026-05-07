import 'package:equatable/equatable.dart';
import 'paragraph_entity.dart';

class ArticleEntity extends Equatable {
  final String id;
  final String heading;
  final String description;
  final List<String> imgUrl;
  final List<String> imgCredits;
  final List<ParagraphEntity> paragraphs;

  const ArticleEntity({
    required this.id,
    required this.heading,
    required this.description,
    required this.imgUrl,
    required this.imgCredits,
    required this.paragraphs,
  });

  @override
  List<Object?> get props => [id, heading];
}
