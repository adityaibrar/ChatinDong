import '../../domain/entities/chat_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _chatRemoteDataSource;

  const ChatRepositoryImpl(this._chatRemoteDataSource);
  @override
  Stream<List<Chat>> getMessage(String chatRoomId) {
    try {
      return _chatRemoteDataSource.getMessage(chatRoomId).map((result) => result
          .map((model) => Chat(
                chatRoom: model.chatRoom,
                content: model.content,
                senderId: model.senderId,
                receiverId: model.receiverId,
                timestamp: model.timestamp,
              ))
          .toList());
    } catch (e) {
      throw Exception('Terjadi Kesalahan implementasi get message $e');
    }
  }

  @override
  Future<void> sendMessage(Chat chat) async {
    try {
      final chatModel = ChatModel(
        chatRoom: chat.chatRoom,
        content: chat.content,
        senderId: chat.senderId,
        receiverId: chat.receiverId,
        timestamp: chat.timestamp,
      );
      await _chatRemoteDataSource.sendMessage(chatModel);
    } catch (e) {
      throw Exception('Terjadi Kesalahan Implementasi send message $e');
    }
  }
}
