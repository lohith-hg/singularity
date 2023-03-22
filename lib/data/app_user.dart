import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser {
  String? id;
  String? name;
  String? bio;
  String? age;
  String? role;
  String? occupation;
  String? phone;
  String? country;
  List<String>? favMovies;
   List<String>? following;
  DateTime? createdAt;

  @JsonKey(ignore: true)
  DocumentReference? reference;

  AppUser({
    this.id,
    this.name,
    this.bio,
    this.age,
    this.role,
    this.occupation,
    this.phone,
    this.country,
    this.favMovies,
    this.following,
    this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  factory AppUser.fromSnapshot(DocumentSnapshot snapshot) {
    final user = AppUser.fromJson(snapshot.data() as Map<String, dynamic>);
    user.reference = snapshot.reference;
    user.id = snapshot.reference.id;
    return user;
  }

  /// Connect the generated [_$AppUserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
