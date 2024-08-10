import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injection.dart';
import '../../domain/usecases/auth_login.dart';
import '../../domain/usecases/auth_register.dart';
import '../../domain/usecases/auth_signout.dart';
import '../bloc/authentication_bloc.dart';
import 'login_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(
        authlogin: locator<AuthLogin>(),
        authregister: locator<AuthRegister>(),
        logout: locator<AuthSignOut>(),
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
                .showSnackBar(SnackBar(content: Text(state.e.toString())));
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationInitial ||
                state is Unauthenticated ||
                state is AuthError) {
              return const LoginScreen();
            } else if (state is AuthenticationLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
