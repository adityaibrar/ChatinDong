import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme.dart';
import '../../../../core/utils/image_converter.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../bloc/message/message_bloc.dart';
import '../widgets/message_list.dart';

class MessagePage extends StatefulWidget {
  final MessageEntity message;

  const MessagePage({super.key, required this.message});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  String? _senderId;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _messageController = TextEditingController();

    _messageController.addListener(() {
      setState(() {});
    });

    final state = context.read<AuthenticationBloc>().state;
    if (state is Authenticated) {
      _senderId = state.user.uid;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MessageBloc>().add(
          GetMessagesRequested(
            message: MessageEntity(
              senderUid: widget.message.senderUid,
              recipientUid: widget.message.recipientUid,
            ),
          ),
        );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) {
      return;
    }

    final state = context.read<AuthenticationBloc>().state;
    if (state is Authenticated) {
      _senderId = state.user.uid;
    }

    final messageState = context.read<MessageBloc>().state;
    int totalUnreadMessages = 0;
    if (messageState is GetMessagesSuccess) {
      totalUnreadMessages = messageState.messages
          .where((msg) => !msg.isSeen! && msg.senderUid == _senderId)
          .length;
    }
    totalUnreadMessages += 1;

    final message = MessageEntity(
      senderUid: _senderId!,
      recipientUid: widget.message.recipientUid,
      senderName: widget.message.senderName,
      recipientName: widget.message.recipientName,
      message: _messageController.text,
      isSeen: false,
      createdAt: DateTime.now(),
    );

    BlocProvider.of<MessageBloc>(context).add(
      SendMessageRequested(
        chat: ChatEntity(
          senderUid: _senderId!,
          recipientUid: widget.message.recipientUid,
          senderName: widget.message.senderName,
          recipientName: widget.message.recipientName,
          senderProfile: widget.message.senderProfile,
          recipientProfile: widget.message.recipientProfile,
          totalUnreadMessages: totalUnreadMessages,
        ),
        message: message,
      ),
    );
    _messageController.clear();
    scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MessageAppBar(
        recipientName: widget.message.recipientName,
        recipientProfile: widget.message.recipientProfile,
      ),
      body: Column(
        children: [
          MessageList(
            scrollController: _scrollController,
            senderId: _senderId,
          ),
          messageInputVield(
            messageController: _messageController,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget messageInputVield({
    required TextEditingController messageController,
    required void Function() onSendMessage,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              style: blackTextStyle.copyWith(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Ketik pesan',
                hintStyle: whiteTextStyle.copyWith(color: Colors.grey),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color:
                  messageController.text.isEmpty ? Colors.grey : primaryColor,
            ),
            onPressed: onSendMessage,
          ),
        ],
      ),
    );
  }
}

// AppBar untuk MessagePage
class MessageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? recipientName;
  final String? recipientProfile;

  const MessageAppBar({
    super.key,
    required this.recipientName,
    required this.recipientProfile,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: base64ToImageProvider(recipientProfile ?? ''),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            recipientName ?? '',
            style: whiteTextStyle.copyWith(
              fontSize: 18,
              fontWeight: semiBold,
            ),
          ),
        ],
      ),
      backgroundColor: primaryColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
