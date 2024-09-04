import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme.dart';
import '../../../../core/utils/chat_util.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../../authentication/presentation/widgets/custom_texfield.dart';
import '../../../chat/presentation/pages/chat_screen.dart';
import '../bloc/friends_bloc.dart';
import 'friends_search_screen.dart';

class FriendsUserScreen extends StatefulWidget {
  const FriendsUserScreen({super.key});

  @override
  State<FriendsUserScreen> createState() => FriendsUserScreenState();
}

class FriendsUserScreenState extends State<FriendsUserScreen> {
  final TextEditingController _searchText = TextEditingController();
  String? _userId;

  @override
  void initState() {
    super.initState();
    context.read<FriendsBloc>().add(GetFriendsEvent());
    context.read<AuthenticationBloc>().add(Check());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Saat user berhasil terautentikasi, simpan userId di state lokal
            setState(() {
              _userId = state.user.uid;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InputField(
                controller: _searchText,
                labelText: 'Cari Teman',
                onChanged: (query) {
                  context.read<FriendsBloc>().add(SearchMyFriends(query));
                },
                borderColor: blackColor,
                cursorColor: blackColor,
                style: blackTextStyle,
              ),
              Expanded(
                child: BlocBuilder<FriendsBloc, FriendsState>(
                  builder: (context, state) {
                    if (state is FriendLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is FriendError) {
                      return Center(
                        child: Text(
                          'Terjadi kesalahan saat pencarian teman: ${state.message}',
                          style: blackTextStyle.copyWith(
                            fontWeight: bold,
                            fontSize: 18,
                          ),
                        ),
                      );
                    } else if (state is FriendGet || state is FriendLoaded) {
                      final friends = state is FriendGet
                          ? state.myFriends
                          : (state as FriendLoaded).friends;

                      if (friends.isEmpty) {
                        return Center(
                          child: Text(
                            'Teman tidak ditemukan',
                            style: blackTextStyle.copyWith(
                              fontWeight: bold,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          final friend = friends[index];
                          return ListTile(
                            leading: Icon(
                              Icons.person,
                              color: primaryColor,
                            ),
                            title: Text(
                              friend.userName,
                              style: blackTextStyle.copyWith(
                                fontWeight: bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              friend.email,
                              style:
                                  blackTextStyle.copyWith(color: Colors.grey),
                            ),
                            onTap: () {
                              // Panggil event Check dan navigasikan setelah user id siap
                              context.read<AuthenticationBloc>().add(Check());
                              if (_userId != null) {
                                final roomId = generateChatRoomId(
                                    _userId.toString(), friend.uid);
                                log(roomId);
                                Navigator.pushNamed(
                                  context,
                                  ChatScreen
                                      .routeName, // Ganti dengan route name yang sesuai
                                  arguments: {
                                    'receiverId': friend.uid,
                                    'receiverName': friend.userName,
                                    'chatRoomId': roomId,
                                  },
                                );
                              } else {
                                log('User ID belum tersedia');
                              }
                            },
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'Anda tidak memiliki teman',
                          style: blackTextStyle.copyWith(
                            fontWeight: bold,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.person_add,
          color: primaryColor,
        ),
        onPressed: () {
          Navigator.pushNamed(context, SearchFriendsPage.routeName);
        },
      ),
    );
  }
}
