import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/injection.dart';
import 'core/routes.dart';
import 'core/theme.dart';
import 'features/authentication/domain/usecases/auth_get_user.dart';
import 'features/authentication/domain/usecases/auth_login.dart';
import 'features/authentication/domain/usecases/auth_register.dart';
import 'features/authentication/domain/usecases/auth_signout.dart';
import 'features/authentication/presentation/bloc/authentication_bloc.dart';
import 'features/chat/domain/usecases/get_message.dart';
import 'features/chat/domain/usecases/send_message.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/friends/domain/usecases/add_friends.dart';
import 'features/friends/domain/usecases/get_friends.dart';
import 'features/friends/domain/usecases/search_friends.dart';
import 'features/friends/domain/usecases/search_people.dart';
import 'features/friends/presentation/bloc/friends_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setUpInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DashboardBloc()),
        BlocProvider(
          create: (context) => AuthenticationBloc(
            authlogin: locator<AuthLogin>(),
            authregister: locator<AuthRegister>(),
            logout: locator<AuthSignOut>(),
            authGetUser: locator<AuthGetUser>(),
          ),
        ),
        BlocProvider(
          create: (context) => FriendsBloc(
            getUser: locator<AuthGetUser>(),
            addFriends: locator<AddFriends>(),
            searchPeople: locator<SearchPeople>(),
            getFriends: locator<GetFriends>(),
            searchFriends: locator<SearchFriends>(),
          ),
        ),
        BlocProvider(
          create: (context) => ChatBloc(
            sendMessage: locator<SendMessage>(),
            getMessage: locator<GetMessage>(),
          ),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
