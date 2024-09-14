import '../entities/chat_entity.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageUsecase {
  final ChatRepository _chatRepository;

  const SendMessageUsecase(this._chatRepository);

  Future<void> execute(ChatEntity chat, MessageEntity message) async {
    return await _chatRepository.sendMessage(chat, message);
  }
}
