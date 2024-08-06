import 'package:chatin_dong/features/authentication/data/datasources/authentication_data_source.dart';
import 'package:chatin_dong/features/authentication/data/repositories/auth_repository.dart';
import 'package:chatin_dong/features/authentication/domain/usecases/auth_login.dart';
import 'package:chatin_dong/features/authentication/domain/usecases/auth_register.dart';
import 'package:chatin_dong/features/authentication/domain/usecases/auth_signout.dart';
import 'package:chatin_dong/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:chatin_dong/features/authentication/presentation/pages/auth_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(
            authlogin: AuthLogin(AuthRepositoryImpl(FirebaseAuthDataSource(
                FirebaseAuth.instance, FirebaseFirestore.instance))),
            authregister: AuthRegister(AuthRepositoryImpl(
                FirebaseAuthDataSource(
                    FirebaseAuth.instance, FirebaseFirestore.instance))),
            logout: AuthSignOut(AuthRepositoryImpl(FirebaseAuthDataSource(
                FirebaseAuth.instance, FirebaseFirestore.instance))),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Firebase Auth',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthScreen(),
        routes: {
          // '/chat': (context) => ChatScreen(),
        },
      ),
    );
  }
}
