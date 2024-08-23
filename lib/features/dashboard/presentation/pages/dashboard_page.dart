import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../../core/theme.dart';
import '../../../friends/presentation/pages/friends_screens.dart';
import '../bloc/dashboard_bloc.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Widget> page = <Widget>[
    const Text('tab 1'),
    const FriendsUserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            automaticallyImplyLeading: false,
            leading: SvgPicture.asset('assets/icons/logo_app_bar.svg'),
            title: Text(
              'Chatin Dong',
              style: whiteTextStyle.copyWith(
                fontSize: 18,
                fontWeight: semiBold,
              ),
            ),
          ),
          body: Center(
            child: page.elementAt(state.selectedIndex),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: whiteColor,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: GNav(
                  tabBorderRadius: 15,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  selectedIndex: state.selectedIndex,
                  onTabChange: (index) {
                    context.read<DashboardBloc>().add(PageTapped(index));
                  },
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  tabBackgroundColor: primaryColor,
                  activeColor: whiteColor,
                  iconSize: 20,
                  color: primaryColor,
                  tabs: const [
                    GButton(
                      icon: Icons.chat,
                      text: ' Chat',
                    ),
                    GButton(
                      icon: Icons.group,
                      text: ' Contact',
                    ),
                  ],
                  textStyle: whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: semiBold,
                  ),
                  textSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
