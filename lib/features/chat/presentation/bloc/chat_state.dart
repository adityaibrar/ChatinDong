part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Chat> messages;

  const ChatLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatLoading extends ChatState {}

class ChatError extends ChatState {
  final String e;

  const ChatError(this.e);

  @override
  List<Object> get props => [e];
}
