import 'package:flutter/material.dart';

import '../../domain/entities/chat_entity.dart';
import 'chat_item.dart';

class ChatListView extends StatelessWidget {
  final List<ChatEntity> chats;
  const ChatListView({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ChatItem(chat: chat);
      },
    );
  }
}
