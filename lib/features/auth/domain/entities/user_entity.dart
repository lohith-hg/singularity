import 'package:equatable/equatable.dart';

// Shared between auth and profile features.
class UserEntity extends Equatable {
  final String id;
  final String? name;
  final String? bio;
  final String? age;
  final String? occupation;
  final String? email;
  final String? country;
  final DateTime? createdAt;
  final Map<String, bool> preferences;
  final int wallpaperCount;

  const UserEntity({
    required this.id,
    this.name,
    this.bio,
    this.age,
    this.occupation,
    this.email,
    this.country,
    this.createdAt,
    this.preferences = const {},
    this.wallpaperCount = 0,
  });

  // Returns a new instance with updated fields — needed because BLoC states are immutable.
  UserEntity copyWith({
    String? name,
    String? bio,
    String? age,
    String? occupation,
    String? email,
    String? country,
    Map<String, bool>? preferences,
    int? wallpaperCount,
  }) {
    return UserEntity(
      id: id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      age: age ?? this.age,
      occupation: occupation ?? this.occupation,
      email: email ?? this.email,
      country: country ?? this.country,
      createdAt: createdAt,
      preferences: preferences ?? this.preferences,
      wallpaperCount: wallpaperCount ?? this.wallpaperCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    bio,
    age,
    occupation,
    email,
    country,
    preferences,
    wallpaperCount,
  ];
}
