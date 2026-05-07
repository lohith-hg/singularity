import 'package:equatable/equatable.dart';

// Astronomy Picture of the Day entity — shared by Cosmo Daily and Sky Stories.
class ApodEntity extends Equatable {
  final String copyright;
  final DateTime date;
  final String explanation;
  final String hdurl;
  final String mediaType;
  final String serviceVersion;
  final String title;
  final String url;

  const ApodEntity({
    required this.copyright,
    required this.date,
    required this.explanation,
    required this.hdurl,
    required this.mediaType,
    required this.serviceVersion,
    required this.title,
    required this.url,
  });

  @override
  List<Object?> get props => [date, title];
}
