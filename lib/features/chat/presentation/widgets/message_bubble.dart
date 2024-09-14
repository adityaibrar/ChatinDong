import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme.dart';
import '../../domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isSentByMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSentByMe ? primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.message ?? '',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  color: isSentByMe ? Colors.white : Colors.black,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(message.createdAt!),
                      style: blackTextStyle.copyWith(
                        fontSize: 10,
                        color: isSentByMe ? Colors.white : Colors.black,
                      ),
                    ),
                    if (isSentByMe)
                      Icon(
                        Icons.done_all,
                        color: message.isSeen == true
                            ? secondaryColor
                            : whiteColor,
                        size: 15,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
