import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme.dart';
import '../../../../core/utils/image_converter.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../pages/message_screen.dart';

class ChatItem extends StatelessWidget {
  final ChatEntity chat;
  const ChatItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: CircleAvatar(
        backgroundImage: base64ToImageProvider(chat.senderProfile ?? ''),
      ),
      title: Text(
        chat.senderName ?? '',
        style: blackTextStyle.copyWith(
          fontSize: 16,
          fontWeight: semiBold,
        ),
      ),
      subtitle: Text(
        chat.recentTextMessage ?? '',
        style: blackTextStyle.copyWith(
          color: Colors.black54,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        children: [
          Text(
            DateFormat('HH:mm').format(chat.createdAt!),
            style: blackTextStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          if (chat.totalUnreadMessages != null &&
              chat.totalUnreadMessages!.toInt() > 0)
            Badge(
              backgroundColor: primaryColor,
              label: Text(
                chat.totalUnreadMessages!.toInt().toString(),
              ),
            )
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagePage(
              message: MessageEntity(
                senderUid: chat.senderUid,
                recipientUid: chat.recipientUid,
                senderName: chat.senderName,
                recipientName: chat.recipientName,
                senderProfile: chat.senderProfile,
              ),
            ),
          ),
        );
      },
    );
  }
}
