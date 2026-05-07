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
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      id: snapshot.id,
      name: data['name'] as String?,
      bio: data['bio'] as String?,
      age: data['age'] as String?,
      occupation: data['occupation'] as String?,
      email: data['email'] as String?,
      country: data['country'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'bio': bio,
        'age': age,
        'occupation': occupation,
        'email': email,
        'country': country,
        'createdAt': createdAt,
      };
}
