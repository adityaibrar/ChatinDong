part of 'message_bloc.dart';

sealed class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

final class MessageInitial extends MessageState {}

class GetMessagesSuccess extends MessageState {
  final List<MessageEntity> messages;

  const GetMessagesSuccess({required this.messages});

  @override
  List<Object> get props => [messages];
}

class MessageLoading extends MessageState {}

class MessageFailure extends MessageState {
  final String error;

  const MessageFailure({required this.error});

  @override
  List<Object> get props => [error];
}
