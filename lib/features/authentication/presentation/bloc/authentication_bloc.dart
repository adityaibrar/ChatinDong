import '../../domain/entities/user_authentication.dart';
import '../../domain/usecases/auth_login.dart';
import '../../domain/usecases/auth_register.dart';
import '../../domain/usecases/auth_signout.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthLogin authlogin;
  final AuthRegister authregister;
  final AuthSignOut logout;

  AuthenticationBloc({
    required this.authlogin,
    required this.authregister,
    required this.logout,
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
          emit(Authenticated(user));
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      }
      if (event is Logout) {
        emit(AuthenticationLoading());
        await logout.execute();
        emit(Unauthenticated());
      }
    });
  }
}
