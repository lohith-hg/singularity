import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:singularity/features/auth/data/models/user_model.dart';
import 'package:singularity/features/auth/domain/entities/user_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel?> getUserProfile(String userId);
  Future<void> updateUserProfile(UserEntity user);
  Future<void> createUserProfile(UserEntity user);
  Future<void> incrementWallpaperCount(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Future<UserModel?> getUserProfile(String userId) async {
    final doc = await _usersCollection.doc(userId).get();
    if (!doc.exists) {
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null || authUser.uid != userId) return null;

      final user = UserModel(
        id: authUser.uid,
        name: authUser.displayName,
        email: authUser.email,
        bio: 'Exploring the universe, one shot at a time!',
        createdAt: DateTime.now(),
      );
      await createUserProfile(user);
      return user;
    }
    return UserModel.fromSnapshot(doc);
  }

  @override
  Future<void> updateUserProfile(UserEntity user) async {
    await _usersCollection.doc(user.id).update({
      'name': user.name,
      'bio': user.bio,
      'age': user.age,
      'occupation': user.occupation,
      'country': user.country,
      'preferences': user.preferences,
    });
  }

  @override
  Future<void> createUserProfile(UserEntity user) async {
    await _usersCollection.doc(user.id).set({
      'name': user.name,
      'bio': user.bio,
      'age': user.age,
      'occupation': user.occupation,
      'email': user.email,
      'country': user.country,
      'createdAt': user.createdAt,
      'preferences': user.preferences,
      'wallpaperCount': user.wallpaperCount,
    });
  }

  @override
  Future<void> incrementWallpaperCount(String userId) async {
    await _usersCollection.doc(userId).update({
      'wallpaperCount': FieldValue.increment(1),
    });
  }
}
