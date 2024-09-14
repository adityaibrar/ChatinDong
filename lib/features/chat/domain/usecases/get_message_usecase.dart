import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessageUsecase {
  final ChatRepository _chatRepository;

  const GetMessageUsecase(this._chatRepository);

  Stream<List<MessageEntity>> execute(MessageEntity message) {
    return _chatRepository.getMessages(message);
  }
}
