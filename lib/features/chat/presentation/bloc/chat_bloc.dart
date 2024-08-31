import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/chat_model.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/usecases/get_message.dart';
import '../../domain/usecases/send_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessage sendMessage;
  final GetMessage getMessage;
  ChatBloc({
    required this.getMessage,
    required this.sendMessage,
  }) : super(ChatInitial()) {
    on<ChatEvent>((event, emit) async {
      if (event is GetMessageEvent) {
        emit(ChatLoading());
        try {
          final result = getMessage.execute(chatRoomId: event.chatRoomId);
          await emit.forEach(result, onData: (message) => ChatLoaded(message));
        } catch (e) {
          emit(ChatError(e.toString()));
        }
      }
      if (event is SendMessageEvent) {
        emit(ChatLoading());
        try {
          await sendMessage.execute(chat: event.message);
        } catch (e) {
          emit(ChatError(e.toString()));
        }
      }
    });
  }
}
