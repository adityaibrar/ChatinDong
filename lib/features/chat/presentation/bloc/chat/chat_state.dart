part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class GetMyChatSuccess extends ChatState {
  final List<ChatEntity> chats;

  const GetMyChatSuccess({required this.chats});

  @override
  List<Object> get props => [chats];
}


class ChatFailure extends ChatState {
  final String error;

  const ChatFailure({required this.error});

  @override
  List<Object> get props => [error];
}
