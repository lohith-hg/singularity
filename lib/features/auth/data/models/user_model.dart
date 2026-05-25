import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:singularity/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    super.name,
    super.bio,
    super.age,
    super.occupation,
    super.email,
    super.country,
    super.createdAt,
    super.preferences = const {},
    super.wallpaperCount = 0,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel.fromMap(snapshot.id, data);
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    final rawPrefs = data['preferences'] as Map<String, dynamic>? ?? {};
    return UserModel(
      id: id,
      name: data['name'] as String?,
      bio: data['bio'] as String?,
      age: data['age'] as String?,
      occupation: data['occupation'] as String?,
      email: data['email'] as String?,
      country: data['country'] as String?,
      createdAt: _parseCreatedAt(data['createdAt']),
      preferences: rawPrefs.map((k, v) => MapEntry(k, v as bool)),
      wallpaperCount: data['wallpaperCount'] as int? ?? 0,
    );
  }

  static DateTime? _parseCreatedAt(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'bio': bio,
    'age': age,
    'occupation': occupation,
    'email': email,
    'country': country,
    'createdAt': createdAt,
    'preferences': preferences,
    'wallpaperCount': wallpaperCount,
  };
}
