import 'package:bus_tracker_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:bus_tracker_app/core/error/exceptions.dart';
import 'package:bus_tracker_app/core/models/user_model.dart';
import 'package:bus_tracker_app/features/auth/domain/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final AppUserCubit appUserCubit;

  AuthBloc({required this.authRepository, required this.appUserCubit})
      : super(AuthInitial()) {
    on<AuthEvent>((event, emit) => emit(AuthLoading()));
    on<AuthSignInWithEmailPassword>(_onAuthSignInWithEmailPassword);
    on<AuthSignInWithGoogle>(_onAuthSignInWithGoogle);
    on<AuthUserLoginCheck>(_onAuthUserLoginCheck);
    on<AuthUserLogout>(_onAuthUserLogout);
  }

  void _onAuthSignInWithEmailPassword(
      AuthSignInWithEmailPassword event, Emitter<AuthState> emit) async {
    final result = await authRepository.signInWithEmailPassword(
        event.email, event.password);
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (driverUserModel) {
        appUserCubit.setUser(null, driverUserModel);
      },
    );
  }

  void _onAuthSignInWithGoogle(
      AuthSignInWithGoogle event, Emitter<AuthState> emit) async {
    final result = await authRepository.signInWithGoogle();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) {
        appUserCubit.setUser(user, null);
      },
    );
  }

  void _onAuthUserLoginCheck(
      AuthUserLoginCheck event, Emitter<AuthState> emit) async {
    try {
      final user = await authRepository.getCurrentUser();
      // ignore: unnecessary_null_comparison
      if (user != null) {
        if (user == "admin") {
          appUserCubit.setUser(null, null, isAdmin: true);
        } else if (user is UserModel) {
          appUserCubit.setUser(user, null);
        } else {
          appUserCubit.setUser(null, user);
        }
      } else {
        emit(AuthInitial());
      }
    } on ServerException catch (e) {
      emit(AuthFailure(e.message));
    }
  }

  void _onAuthUserLogout(AuthUserLogout event, Emitter<AuthState> emit) async {
    final result = await authRepository.signOut();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (res) {
        appUserCubit.setUser(null, null);
        emit(AuthInitial());
      },
    );
  }
}
