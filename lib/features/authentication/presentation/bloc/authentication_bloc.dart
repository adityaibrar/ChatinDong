import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/user_local_storage_data_sources.dart';
import '../../domain/entities/user_authentication.dart';
import '../../domain/usecases/auth_get_user.dart';
import '../../domain/usecases/auth_login.dart';
import '../../domain/usecases/auth_register.dart';
import '../../domain/usecases/auth_set_profile.dart';
import '../../domain/usecases/auth_signout.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthLogin authlogin;
  final AuthRegister authregister;
  final AuthSignOut logout;
  final AuthGetUser authGetUser;
  final AuthSetProfile authSetUpProfile;
  final UserLocalDataSources userLocalDataSources;

  AuthenticationBloc({
    required this.authlogin,
    required this.authregister,
    required this.logout,
    required this.authGetUser,
    required this.authSetUpProfile,
    required this.userLocalDataSources,
  }) : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is Login) {
        emit(AuthenticationLoading());
        try {
          final user = await authlogin.execute(
            event.email,
            event.password,
          );
          emit(ProfileNotSetUp(user));
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
        emit(AuthenticationLoading());
        try {
          final user = await authGetUser.execute();
          final isSetUp = await userLocalDataSources.isProfileSetUp();
          if (isSetUp) {
            emit(Authenticated(user));
          } else {
            emit(ProfileNotSetUp(user));
          }
        } catch (e) {
          emit(Unauthenticated());
        }
      }
      if (event is SetUpProfileEvent) {
        emit(AuthenticationLoading());
        try {
          final user = await authGetUser.execute();
          await authSetUpProfile.execute(
              user: user,
              currentId: user.uid,
              userName: event.userName,
              imageUrl: event.imageUrl);
          emit(SuccessSetUp());
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      }
    });
  }
}
