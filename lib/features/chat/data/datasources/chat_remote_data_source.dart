import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_model.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore _firestore;

  const ChatRemoteDataSource(this._firestore);

  Future<void> sendMessage(ChatModel chatModel) async {
    try {
      await _firestore
          .collection('chatRooms')
          .doc(chatModel.chatRoom)
          .collection(chatModel.chatRoom)
          .add(chatModel.toMap());
    } catch (e) {
      throw Exception('Terjadi kesalahan pengiriman pesan $e');
    }
  }

  Stream<List<ChatModel>> getMessage(String userId) {
    try {
      return _firestore
          .collection('chatRooms')
          .doc(userId)
          .collection(userId)
          .orderBy('timestamp')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ChatModel.fromMap(doc.data()))
              .toList());
    } catch (e) {
      throw Exception('Terjadi kesalahan pengambilan pesan $e');
    }
  }
}
