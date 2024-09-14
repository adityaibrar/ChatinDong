import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _chatDataSource;

  const ChatRepositoryImpl(this._chatDataSource);
  @override
  Stream<List<MessageEntity>> getMessages(MessageEntity message) {
    try {
      return _chatDataSource.getMessages(message);
    } catch (e) {
      throw Exception('terjadi kesalahan $e');
    }
  }

  @override
  Stream<List<ChatEntity>> getMyChat(ChatEntity chat) {
    try {
      return _chatDataSource.getMyChat(chat);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> seenMessageUpdate(MessageEntity message) async {
    try {
      return await _chatDataSource.seenMessageUpdate(message);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> sendMessage(ChatEntity chat, MessageEntity message) async {
    try {
      return await _chatDataSource.sendMessage(chat, message);
    } catch (e) {
      throw Exception(e);
    }
  }
}
