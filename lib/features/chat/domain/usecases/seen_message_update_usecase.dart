import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SeenMessageUpdateUsecase {
  final ChatRepository _chatRepository;

  const SeenMessageUpdateUsecase(this._chatRepository);

  Future<void> execute(MessageEntity message) async {
    return await _chatRepository.seenMessageUpdate(message);
  }
}
