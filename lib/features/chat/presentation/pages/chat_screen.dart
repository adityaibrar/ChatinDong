import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../data/models/chat_model.dart';
import '../bloc/chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late String chatRoomId;
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  String? senderId;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
  }

  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Mengambil argumen setelah context siap
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    chatRoomId = arguments['chatRoomId'] as String;

    // Menginisialisasi BLoC untuk mendapatkan pesan
    context.read<ChatBloc>().add(GetMessageEvent(chatRoomId));
    context.read<AuthenticationBloc>().add(Check());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final receiverId = arguments['receiverId'] as String;
    final receiverName = arguments['receiverName'] as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(
          color: whiteColor,
        ),
        title: Text(
          receiverName,
          style: whiteTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) {
            senderId = state.user.uid;
          }
        },
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                    // Dapatkan list pesan
                    final messages = state.messages;
                    // Mengurutkan pesan dari yang terlama ke yang terbaru jika perlu
                    // (Jika pesan sudah diurutkan di Firestore, langkah ini mungkin tidak diperlukan)
                    final sortedMessages = List.from(messages); // Copy list
                    sortedMessages
                        .sort((a, b) => a.timestamp.compareTo(b.timestamp));
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: sortedMessages.length,
                      itemBuilder: (context, index) {
                        final message = sortedMessages[index];
                        final isSentByMe = message.senderId == senderId;

                        return Align(
                          alignment: isSentByMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color:
                                  isSentByMe ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.content,
                                  style: TextStyle(
                                    color: isSentByMe
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                Text(
                                  DateFormat('HH:mm').format(
                                      message.timestamp), // Format timestamp
                                  style: TextStyle(
                                    color: isSentByMe
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text('Terjadi kesalahan: ${state.e}'));
                  } else {
                    return const Center(child: Text('Tidak ada pesan'));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: 'Ketik pesan...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final content = _messageController.text;
                      if (content.isNotEmpty) {
                        final chatMessage = ChatModel(
                          chatRoom: chatRoomId,
                          senderId: senderId!,
                          receiverId: receiverId,
                          content: content,
                          timestamp: DateTime.now(),
                        );

                        context
                            .read<ChatBloc>()
                            .add(SendMessageEvent(chatMessage));
                        _messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
