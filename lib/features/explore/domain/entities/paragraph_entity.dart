import 'package:equatable/equatable.dart';

class ParagraphEntity extends Equatable {
  final String id;
  final String heading;
  final String? imgUrl;
  final String description;

  const ParagraphEntity({
    required this.id,
    required this.heading,
    this.imgUrl,
    required this.description,
  });

  @override
  List<Object?> get props => [id, heading, description];
}
