// import 'dart:developer';

import '../models/friend_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRemoteDataSources {
  final FirebaseFirestore firebaseFirestore;

  const FriendRemoteDataSources(this.firebaseFirestore);

  Future<List<FriendModel>> searchPeople({required String query}) async {
    try {
      final result = await firebaseFirestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return result.docs
          .map((doc) => FriendModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Pengguna tidak ditemukan');
    }
  }

  Future<List<FriendModel>> searchFriends(
      {required String userId, required String query}) async {
    try {
      final result = await firebaseFirestore
          .collection('friends')
          .doc(userId)
          .collection('userFriends')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return result.docs
          .map((doc) => FriendModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Teman tidak ditemukan $e');
    }
  }

  Future<void> addFriends({
    required String uid,
    required FriendModel friendModel,
  }) async {
    try {
      await firebaseFirestore
          .collection('friends')
          .doc(uid)
          .collection('userFriends')
          .doc(friendModel.uid)
          .set(friendModel.toMap());
    } catch (e) {
      throw Exception('Gagal menambahkan teman $e');
    }
  }

  Future<List<FriendModel>> getFriends({required String userId}) async {
    try {
      final result = await firebaseFirestore
          .collection('friends')
          .doc(userId)
          .collection('userFriends')
          .get();

      final friends = result.docs
          .map((doc) => FriendModel.fromDocumentSnapshot(doc))
          .toList();
      // log('Friends list for user $userId: ${friends.map((friend) => friend.toString()).join(', ')}');

      return friends;
    } catch (e) {
      throw Exception('Gagal mendapatkan data teman $e');
    }
  }
}
