import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/injection.dart';
import 'core/routes.dart';
import 'core/theme.dart';
import 'features/authentication/data/datasources/user_local_storage_data_sources.dart';
import 'features/authentication/domain/usecases/auth_get_user.dart';
import 'features/authentication/domain/usecases/auth_login.dart';
import 'features/authentication/domain/usecases/auth_register.dart';
import 'features/authentication/domain/usecases/auth_set_profile.dart';
import 'features/authentication/domain/usecases/auth_signout.dart';
import 'features/authentication/presentation/bloc/authentication_bloc.dart';
import 'features/chat/domain/usecases/get_message_usecase.dart';
import 'features/chat/domain/usecases/get_my_chat_usecase.dart';
import 'features/chat/domain/usecases/seen_message_update_usecase.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';
import 'features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'features/chat/presentation/bloc/message/message_bloc.dart';
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
            authSetUpProfile: locator<AuthSetProfile>(),
            userLocalDataSources: locator<UserLocalDataSources>(),
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
            getMyChatUsecase: locator<GetMyChatUsecase>(),
          ),
        ),
        BlocProvider(
          create: (context) => MessageBloc(
            getMessageUsecase: locator<GetMessageUsecase>(),
            sendMessageUsecase: locator<SendMessageUsecase>(),
            seenMessageUpdateUsecase: locator<SeenMessageUpdateUsecase>(),
          ),
        ),
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
