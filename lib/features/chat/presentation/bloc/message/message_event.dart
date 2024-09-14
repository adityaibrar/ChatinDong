part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class GetMessagesRequested extends MessageEvent {
  final MessageEntity message;

  const GetMessagesRequested({required this.message});
}

class SendMessageRequested extends MessageEvent {
  final ChatEntity chat;

  final MessageEntity message;

  const SendMessageRequested({required this.chat, required this.message});
}

class SeenMessageUpdate extends MessageEvent {
  final MessageEntity message;

  const SeenMessageUpdate(this.message);
}
