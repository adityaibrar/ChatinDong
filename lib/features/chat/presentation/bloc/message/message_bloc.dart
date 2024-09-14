import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat_entity.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/usecases/get_message_usecase.dart';
import '../../../domain/usecases/seen_message_update_usecase.dart';
import '../../../domain/usecases/send_message_usecase.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessageUsecase getMessageUsecase;
  final SendMessageUsecase sendMessageUsecase;
  final SeenMessageUpdateUsecase seenMessageUpdateUsecase;
  MessageBloc({
    required this.getMessageUsecase,
    required this.sendMessageUsecase,
    required this.seenMessageUpdateUsecase,
  }) : super(MessageInitial()) {
    on<MessageEvent>((event, emit) async {
      if (event is GetMessagesRequested) {
        emit(MessageLoading());
        try {
          final messageStream = getMessageUsecase.execute(event.message);
          await emit.forEach(messageStream,
              onData: (message) => GetMessagesSuccess(messages: message));
        } catch (e) {
          emit(MessageFailure(error: e.toString()));
        }
      }
      if (event is SendMessageRequested) {
        emit(MessageLoading());
        try {
          await sendMessageUsecase.execute(event.chat, event.message);
        } catch (e) {
          emit(MessageFailure(error: e.toString()));
        }
      }
      if (event is SeenMessageUpdate) {
        try {
          log('aku kena hit');
          await seenMessageUpdateUsecase.execute(event.message);
        } catch (e) {
          throw Exception(e.toString());
        }
      }
    });
  }
}
