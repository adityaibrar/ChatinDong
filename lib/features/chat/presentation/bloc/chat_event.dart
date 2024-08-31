part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetMessageEvent extends ChatEvent {
  final String chatRoomId;
  const GetMessageEvent(this.chatRoomId);
}

class SendMessageEvent extends ChatEvent {
  final ChatModel message;

  const SendMessageEvent(this.message);
}
