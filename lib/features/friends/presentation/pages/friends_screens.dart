import 'package:chatin_dong/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/presentation/widgets/custom_texfield.dart';
import '../bloc/friends_bloc.dart';
import 'friends_search_screen.dart';

class FriendsUserScreen extends StatefulWidget {
  const FriendsUserScreen({super.key});

  @override
  State<FriendsUserScreen> createState() => FriendsUserScreenState();
}

class FriendsUserScreenState extends State<FriendsUserScreen> {
  final TextEditingController _searchText = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FriendsBloc>().add(GetFriendsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                            style: blackTextStyle.copyWith(color: Colors.grey),
                          ),
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
