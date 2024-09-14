import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme.dart';
import '../../../../core/utils/image_converter.dart';
import '../../../authentication/presentation/bloc/authentication_bloc.dart';
import '../../../authentication/presentation/widgets/custom_texfield.dart';
import '../../../chat/domain/entities/message_entity.dart';
import '../../../chat/presentation/pages/message_screen.dart';
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
  String? _senderName;

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
              _senderName = state.user.name;
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
                            leading: CircleAvatar(
                              backgroundImage:
                                  base64ToImageProvider(friend.imageUrl),
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
                              // Logika untuk mengarahkan ke halaman MessagePage
                              final messageEntity = MessageEntity(
                                senderUid: _userId,
                                recipientUid: friend.uid,
                                senderName: _senderName, // Nama pengirim
                                recipientName: friend.userName,
                                recipientProfile: friend.imageUrl,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessagePage(
                                    message: messageEntity,
                                  ),
                                ),
                              );
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
