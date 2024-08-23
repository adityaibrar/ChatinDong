import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_authentication.dart';
import '../../domain/usecases/auth_get_user.dart';
import '../../domain/usecases/auth_login.dart';
import '../../domain/usecases/auth_register.dart';
import '../../domain/usecases/auth_signout.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthLogin authlogin;
  final AuthRegister authregister;
  final AuthSignOut logout;
  final AuthGetUser authGetUser;

  AuthenticationBloc({
    required this.authlogin,
    required this.authregister,
    required this.logout,
    required this.authGetUser,
  }) : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is Login) {
        emit(AuthenticationLoading());
        try {
          final user = await authlogin.execute(
            event.email,
            event.password,
          );
          emit(Authenticated(user));
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      }

      if (event is Register) {
        emit(AuthenticationLoading());
        try {
          final user = await authregister.execute(
            event.name,
            event.email,
            event.password,
          );
          emit(SuccesRegister(user));
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      }
      if (event is Logout) {
        emit(AuthenticationLoading());
        await logout.execute();
        emit(Unauthenticated());
      }
      if (event is Check) {
        log('Check event triggered');
        emit(AuthenticationLoading());
        try {
          final user = await authGetUser.execute();
          log('User authenticated: ${user.email}');
          emit(Authenticated(user));
        } catch (e) {
          log('User unauthenticated or error: $e');
          emit(Unauthenticated());
        }
      }
    });
  }
}
