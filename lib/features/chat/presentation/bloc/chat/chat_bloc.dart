import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat_entity.dart';
import '../../../domain/usecases/get_my_chat_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMyChatUsecase getMyChatUsecase;

  ChatBloc({
    required this.getMyChatUsecase,
  }) : super(ChatInitial()) {
    on<ChatEvent>((event, emit) async {
      if (event is GetMyChatRequested) {
        emit(ChatLoading());
        final chatStream = getMyChatUsecase.execute(event.chat);
        await emit.forEach(chatStream,
            onData: (chat) => GetMyChatSuccess(chats: chat));
      }
    });
  }
}
