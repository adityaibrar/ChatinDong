import '../entities/chat_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  Future<void> sendMessage(ChatEntity chat, MessageEntity message);
  Future<void> seenMessageUpdate(MessageEntity message);
  Stream<List<ChatEntity>> getMyChat(ChatEntity chat);
  Stream<List<MessageEntity>> getMessages(MessageEntity message);
}
