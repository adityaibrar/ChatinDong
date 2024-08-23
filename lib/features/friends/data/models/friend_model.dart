import '../../domain/entities/friend_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendModel extends Friend {
  const FriendModel({
    required super.uid,
    required String name,
    required super.email,
  }) : super(
          userName: name,
        );

  // Mengambil data dari Firestore document dan mengubahnya menjadi FriendModel
  factory FriendModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return FriendModel(
      uid: doc.id,
      name: doc['name'],
      email: doc['email'],
    );
  }

  // Mengubah FriendModel ke dalam format map yang akan disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': userName,
      'email': email,
    };
  }

  // Convert entity Friend ke FriendModel
  factory FriendModel.fromEntity(Friend friend) {
    return FriendModel(
      uid: friend.uid,
      name: friend.userName,
      email: friend.email,
    );
  }

  // Convert FriendModel kembali ke Friend entity
  Friend toEntity() {
    return Friend(
      uid: uid,
      userName: userName,
      email: email,
    );
  }
}
