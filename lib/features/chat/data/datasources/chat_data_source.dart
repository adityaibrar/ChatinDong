import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constant/message_type_const.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatDataSource {
  final FirebaseFirestore _firestore;

  const ChatDataSource(this._firestore);

  Future<void> sendMessageBasedOnType(MessageEntity message) async {

    final myMessageRef = _firestore
        .collection('users')
        .doc(message.senderUid)
        .collection('myChat')
        .doc(message.recipientUid)
        .collection('messages');

    final otherMessageRef = _firestore
        .collection('users')
        .doc(message.recipientUid)
        .collection('myChat')
        .doc(message.senderUid)
        .collection('messages');

    String messageId = const Uuid().v1();

    final newMessage = MessageModel(
      senderUid: message.senderUid,
      recipientUid: message.recipientUid,
      senderName: message.senderName,
      recipientName: message.recipientName,
      createdAt: DateTime.now(),
      isSeen: message.isSeen,
      messageType: message.messageType,
      message: message.message,
      messageId: messageId,
    ).toFirestore();

    try {
      await myMessageRef.doc(messageId).set(newMessage);
      await otherMessageRef.doc(messageId).set(newMessage);
    } catch (e) {
      throw Exception("error occur while sending message $e");
    }
  }

  Future<void> sendMessage(ChatEntity chat, MessageEntity message) async {
    await sendMessageBasedOnType(message);

    String recentTextMessage = "";

    switch (message.messageType) {
      case MessageTypeConst.photoMessage:
        recentTextMessage = '📷 Photo';
        break;
      case MessageTypeConst.videoMessage:
        recentTextMessage = '📸 Video';
        break;
      case MessageTypeConst.audioMessage:
        recentTextMessage = '🎵 Audio';
        break;
      case MessageTypeConst.gifMessage:
        recentTextMessage = 'GIF';
        break;
      default:
        recentTextMessage = message.message!;
    }

    await addToChat(ChatEntity(
      createdAt: DateTime.now(),
      senderProfile: chat.senderProfile,
      recipientProfile: chat.recipientProfile,
      recentTextMessage: recentTextMessage,
      recipientName: chat.recipientName,
      senderName: chat.senderName,
      recipientUid: chat.recipientUid,
      senderUid: chat.senderUid,
      totalUnreadMessages: chat.totalUnreadMessages,
    ));
  }

  Future<void> addToChat(ChatEntity chat) async {

    final myChatRef =
        _firestore.collection('users').doc(chat.senderUid).collection('myChat');

    final otherChatRef = _firestore
        .collection('users')
        .doc(chat.recipientUid)
        .collection('myChat');

    final myNewChat = ChatModel(
      createdAt: DateTime.now(),
      senderProfile: chat.senderProfile,
      recipientProfile: chat.recipientProfile,
      recentTextMessage: chat.recentTextMessage,
      recipientName: chat.recipientName,
      senderName: chat.senderName,
      recipientUid: chat.recipientUid,
      senderUid: chat.senderUid,
      // totalUnreadMessages: chat.totalUnreadMessages,
    ).toFirestore();

    final otherNewChat = ChatModel(
      createdAt: DateTime.now(),
      senderProfile: chat.recipientProfile,
      recipientProfile: chat.senderProfile,
      recentTextMessage: chat.recentTextMessage,
      recipientName: chat.senderName,
      senderName: chat.recipientName,
      recipientUid: chat.senderUid,
      senderUid: chat.recipientUid,
      totalUnreadMessages: chat.totalUnreadMessages,
    ).toFirestore();

    try {
      myChatRef.doc(chat.recipientUid).get().then((myChatDoc) async {
        // Create
        if (!myChatDoc.exists) {
          await myChatRef.doc(chat.recipientUid).set(myNewChat);
          await otherChatRef.doc(chat.senderUid).set(otherNewChat);
          return;
        } else {
          // Update
          await myChatRef.doc(chat.recipientUid).update(myNewChat);
          await otherChatRef.doc(chat.senderUid).update(otherNewChat);
          return;
        }
      });
    } catch (e) {
      throw Exception("error occur while adding to chat $e");
    }
  }

  Future<void> seenMessageUpdate(MessageEntity message) async {
    final myMessagesRef = _firestore
        .collection('users')
        .doc(message.senderUid)
        .collection('myChat')
        .doc(message.recipientUid)
        .collection('messages')
        .doc(message.messageId);

    final otherMessagesRef = _firestore
        .collection('users')
        .doc(message.recipientUid)
        .collection('myChat')
        .doc(message.senderUid)
        .collection('messages')
        .doc(message.messageId);

    final updateMyUnread = _firestore
        .collection('users')
        .doc(message.senderUid)
        .collection('myChat')
        .doc(message.recipientUid);

    final updateOtherUnread = _firestore
        .collection('users')
        .doc(message.recipientUid)
        .collection('myChat')
        .doc(message.senderUid);

    await myMessagesRef.update({"is_seen": true});
    await otherMessagesRef.update({"is_seen": true});
    await updateMyUnread.update({"total_unread_messages": 0});
    await updateOtherUnread.update({"total_unread_messages": 0});
  }

  Stream<List<ChatEntity>> getMyChat(ChatEntity chat) {
    final myChatRef = _firestore
        .collection('users')
        .doc(chat.senderUid)
        .collection('myChat')
        .orderBy("created_at", descending: true);

    return myChatRef.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ChatModel.fromFirestore(e)).toList());
  }

  Stream<List<MessageEntity>> getMessages(MessageEntity message) {
    try {
      final messagesRef = _firestore
          .collection('users')
          .doc(message.senderUid)
          .collection('myChat')
          .doc(message.recipientUid)
          .collection('messages')
          .orderBy('created_at', descending: false);

      return messagesRef.snapshots().map((querySnapshot) => querySnapshot.docs
          .map((e) => MessageModel.fromFirestore(e))
          .toList());
    } catch (e) {
      throw Exception('terjadi kesalahan get message $e');
    }
  }
}
