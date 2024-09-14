import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/message/message_bloc.dart';
import 'message_bubble.dart';

class MessageList extends StatelessWidget {
  final ScrollController scrollController;
  final String? senderId;

  const MessageList({
    super.key,
    required this.scrollController,
    required this.senderId,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is MessageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetMessagesSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              scrollController.jumpTo(scrollController.position.maxScrollExtent);
            });

            final messages = state.messages;
            return ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSentByMe = message.senderUid == senderId;

                if (!isSentByMe && message.isSeen != true) {
                  context.read<MessageBloc>().add(SeenMessageUpdate(message));
                }

                return MessageBubble(
                  message: message,
                  isSentByMe: isSentByMe,
                );
              },
            );
          } else if (state is MessageFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return Container();
        },
      ),
    );
  }
}