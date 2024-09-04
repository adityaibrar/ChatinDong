import 'package:chatin_dong/features/authentication/presentation/pages/set_up_profile_screen.dart';

import '../features/authentication/presentation/pages/auth_pages.dart';
import '../features/authentication/presentation/pages/login_screen.dart';
import '../features/authentication/presentation/pages/register_pages.dart';
import '../features/chat/presentation/pages/chat_screen.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/friends/presentation/pages/friends_search_screen.dart';

dynamic routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  DashboardPage.routeName: (context) => const DashboardPage(),
  SearchFriendsPage.routeName: (context) => const SearchFriendsPage(),
  ChatScreen.routeName: (context) => const ChatScreen(),
  SetUpProfileScreen.routeName: (context) => const SetUpProfileScreen(),
};
