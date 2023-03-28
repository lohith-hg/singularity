// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      id: json['id'] as String?,
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      age: json['age'] as String?,
      role: json['role'] as String?,
      occupation: json['occupation'] as String?,
      email: json['email'] as String?,
      country: json['country'] as String?,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      favMovies: (json['favMovies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      following: (json['following'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bio': instance.bio,
      'age': instance.age,
      'role': instance.role,
      'occupation': instance.occupation,
      'email': instance.email,
      'country': instance.country,
      'interests': instance.interests,
      'favMovies': instance.favMovies,
      'following': instance.following,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
