import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../domain/entities/chat_entity.dart';
import '../bloc/chat/chat_bloc.dart';
import '../widgets/chat_list_view.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  String? _userId;
  @override
  void initState() {
    super.initState();
    final state = context.read<AuthenticationBloc>().state;
    if (state is Authenticated) {
      _userId = state.user.uid;
    }
    context.read<ChatBloc>().add(
          GetMyChatRequested(
            chat: ChatEntity(senderUid: _userId),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetMyChatSuccess) {
            return ChatListView(chats: state.chats);
          } else if (state is ChatFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }

          return const Center(child: Text('No chats available.'));
        },
      ),
    );
  }
}
