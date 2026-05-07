import 'package:equatable/equatable.dart';

class FactEntity extends Equatable {
  final String id;
  final String heading;
  final String description;

  const FactEntity({
    required this.id,
    required this.heading,
    required this.description,
  });

  @override
  List<Object?> get props => [id, heading, description];
}
