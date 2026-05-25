import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/entities/apod_entity.dart';
import '../models/saved_item_model.dart';

abstract class SavedRemoteDataSource {
  Future<List<SavedItemModel>> getSavedItems(String uid);
  Future<void> saveApod(String uid, ApodEntity apod);
  Future<void> unsaveApod(String uid, String apodDate);
}

class SavedRemoteDataSourceImpl implements SavedRemoteDataSource {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String uid) =>
      _firestore.collection('users').doc(uid).collection('saved_items');

  @override
  Future<List<SavedItemModel>> getSavedItems(String uid) async {
    final snapshot = await _collection(
      uid,
    ).orderBy('savedAt', descending: true).get();
    return snapshot.docs
        .map((doc) => SavedItemModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<void> saveApod(String uid, ApodEntity apod) async {
    final dateKey = apod.date.toIso8601String().split('T').first;
    final model = SavedItemModel(apod: apod, savedAt: DateTime.now());
    await _collection(uid).doc(dateKey).set(model.toMap());
  }

  @override
  Future<void> unsaveApod(String uid, String apodDate) async {
    final dateKey = apodDate.split('T').first;
    await _collection(uid).doc(dateKey).delete();
  }
}
