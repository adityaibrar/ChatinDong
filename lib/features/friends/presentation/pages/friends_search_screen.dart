import 'package:chatin_dong/features/authentication/presentation/widgets/custom_texfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme.dart';
import '../bloc/friends_bloc.dart';

class SearchFriendsPage extends StatefulWidget {
  static const String routeName = '/search-friends';
  const SearchFriendsPage({super.key});

  @override
  State<SearchFriendsPage> createState() => _SearchFriendsPageState();
}

class _SearchFriendsPageState extends State<SearchFriendsPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchText = TextEditingController();
    final FriendsBloc friendsBloc = BlocProvider.of<FriendsBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(
          color: whiteColor,
        ),
        title: Text(
          'Cari Teman',
          style: whiteTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InputField(
              controller: searchText,
              labelText: 'Cari Teman Baru',
              onChanged: (query) {
                friendsBloc.add(SearchPeopleEvent(query));
              },
              borderColor: blackColor,
              cursorColor: blackColor,
              style: blackTextStyle,
            ),
            BlocListener<FriendsBloc, FriendsState>(
              listener: (context, state) {
                if (state is FriendAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Friend added successfully!')),
                  );
                } else if (state is FriendError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                }
              },
              child: BlocBuilder<FriendsBloc, FriendsState>(
                builder: (context, state) {
                  if (state is FriendLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is FriendLoaded) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.friends.length,
                        itemBuilder: (context, index) {
                          final friend = state.friends[index];
                          return ListTile(
                            title: Text(friend.userName),
                            subtitle: Text(friend.email),
                            trailing: IconButton(
                              icon: const Icon(Icons.person_add),
                              onPressed: () {
                                friendsBloc.add(AddFriendsEvent(friend));
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is FriendError) {
                    return Text(
                        'Terjadi Kesalah saat pencarian orang: ${state.message}');
                  } else {
                    return Center(
                        child: Text(
                      'Pengguna tidak ditemukan',
                      style: blackTextStyle.copyWith(
                        fontWeight: bold,
                        fontSize: 18,
                      ),
                    ));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
