import 'package:chatin_dong/features/authentication/data/datasources/authentication_data_source.dart';
import 'package:chatin_dong/features/authentication/data/repositories/auth_repository.dart';
import 'package:chatin_dong/features/authentication/domain/usecases/auth_login.dart';
import 'package:chatin_dong/features/authentication/domain/usecases/auth_register.dart';
import 'package:chatin_dong/features/authentication/domain/usecases/auth_signout.dart';
import 'package:chatin_dong/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:chatin_dong/features/authentication/presentation/pages/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(
        authlogin: AuthLogin(AuthRepositoryImpl(FirebaseAuthDataSource(FirebaseAuth.instance, FirebaseFirestore.instance))),
        authregister: AuthRegister(AuthRepositoryImpl(FirebaseAuthDataSource(FirebaseAuth.instance, FirebaseFirestore.instance))),
        logout: AuthSignOut(AuthRepositoryImpl(FirebaseAuthDataSource(FirebaseAuth.instance, FirebaseFirestore.instance))),
      ),
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Berhasil Registrasi')));
            Navigator.pushReplacementNamed(context, '/chat');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.e)));
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationInitial || state is Unauthenticated) {
              return const LoginScreen();
            } else if (state is AuthenticationLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Container();
          },
        ),
      ),
    );
  }
}
